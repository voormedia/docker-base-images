#!/bin/bash

if [ -z "${NOTION_USERNAME}" ]; then
  echo "NOTION_USERNAME is not set."
  has_errors=true
fi

if [ -z "${NOTION_PASSWORD}" ]; then
  echo "NOTION_PASSWORD is not set."
  has_errors=true
fi

python3 /srv/retrieve_cookie.py

if [ ! -f "/srv/token.json" ]; then
  echo "Error: Could not retrieve Notion token."
  has_errors=true
fi

if [ -z "${B2_BUCKET}" ]; then
  echo "B2_BUCKET is not set."
  has_errors=true
fi

if [ -z "${B2_ENCRYPTION_KEY}" ]; then
  echo "B2_ENCRYPTION_KEY is not set."
  has_errors=true
fi

if [ -z "${B2_APPLICATION_KEY_ID}" ]; then
  echo "B2_APPLICATION_KEY_ID is not set."
  has_errors=true
fi

if [ -z "${B2_APPLICATION_KEY}" ]; then
  echo "B2_APPLICATION_KEY is not set."
  has_errors=true
fi

if [ "${has_errors}" = true ]; then
  exit 1
fi

NOTION_TOKEN=$(jq -r '.token_v2' /srv/token.json)

BACKUP_DIR="/srv/backups"
DATE=$(date +"%Y-%m-%d-%H-%M-%S")
FILENAME="${DATE}-notion-export.zip"
ENCRYPTED_FILENAME="${FILENAME}.encrypted"
SPACE_ID="9f592356-5cae-4bf8-8199-9a0455a6cf86"

echo "Enqueuing Notion export task..."
TASK_ID=$(curl -s -X POST "https://www.notion.so/api/v3/enqueueTask" \
  -H "Content-Type: application/json" \
  -H "Cookie: token_v2=$NOTION_TOKEN" \
  -d '{
        "task": {
          "eventName": "exportSpace",
          "request": {
            "spaceId": "'"${SPACE_ID}"'",
            "exportOptions": {
              "exportType": "html",
              "timeZone": "Europe/Amsterdam",
              "locale": "en"
            }
          }
        }
      }' | jq -r '.taskId')

if [ -z "$TASK_ID" ]; then
  echo "Failed to enqueue export task."
  exit 1
fi
echo "Task enqueued with ID: $TASK_ID"

check_task() {
  curl -s -X POST "https://www.notion.so/api/v3/getTasks" \
    -H "Content-Type: application/json" \
    -H "Cookie: token_v2=$NOTION_TOKEN" \
    -d '{"taskIds": ["'"$TASK_ID"'"]}' | jq -r '.results[0].state'
}

echo "Checking export task status..."
while true; do
  STATE=$(check_task)
  if [ "$STATE" == "success" ]; then
    echo "Export task completed."
    break
  elif [ "$STATE" == "failure" ]; then
    echo "Export task failed."
    exit 1
  else
    echo "Task still in progress..."
    sleep 10
  fi
done

DOWNLOAD_URL=$(curl -s -X POST "https://www.notion.so/api/v3/getTasks" \
  -H "Content-Type: application/json" \
  -H "Cookie: token_v2=$NOTION_TOKEN" \
  -d '{"taskIds": ["'"$TASK_ID"'"]}' | jq -r '.results[0].status.exportURL')

if [ -z "$DOWNLOAD_URL" ]; then
  echo "Failed to retrieve download URL."
  exit 1
fi

mkdir -p "$BACKUP_DIR"
echo "Starting download from $DOWNLOAD_URL"
curl -L "$DOWNLOAD_URL" -o "$BACKUP_DIR/$FILENAME" -H "Cookie: token_v2=$NOTION_TOKEN"
if [ $? -ne 0 ]; then
  echo "Download failed."
  exit 1
fi
echo "Download completed: $BACKUP_DIR/$FILENAME"

echo "Encrypting the backup..."
openssl enc -aes-256-cbc -md md5 -in "$BACKUP_DIR/$FILENAME" -out "$BACKUP_DIR/$ENCRYPTED_FILENAME" -pass pass:"$B2_ENCRYPTION_KEY"
if [ $? -ne 0 ]; then
  echo "Encryption failed."
  exit 1
fi
echo "Encryption completed: $BACKUP_DIR/$ENCRYPTED_FILENAME"

echo "Uploading encrypted backup to Backblaze B2..."
b2 authorize-account "$B2_ACCOUNT_ID" "$B2_APPLICATION_KEY"
b2 upload-file --noProgress "$B2_BUCKET" "$BACKUP_DIR/$ENCRYPTED_FILENAME" "$ENCRYPTED_FILENAME"
if [ $? -ne 0 ]; then
  echo "Upload failed."
  exit 1
fi
echo "Upload completed."

# Step 7: Cleanup (Optional)
rm "$BACKUP_DIR/$FILENAME"
echo "Temporary backup file deleted. Backup process complete."