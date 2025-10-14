#!/bin/bash
set -e

has_errors=false

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

if [ -z "${BACKUP_PATTERNS}" ]; then
  echo "BACKUP_PATTERNS is not set."
  has_errors=true
fi

# Optional single exclusion pattern
EXCLUSION_PATTERN=${EXCLUSION_PATTERN:-""}

if [ "${has_errors}" = true ]; then
  exit 1
fi

b2 account authorize

DATE=$(date +"%Y-%m-%d_%H:%M:%S")
mkdir "/tmp/${DATE}"
BUCKETS=$(gsutil ls)

IFS=',' read -r -a PATTERNS <<< "$BACKUP_PATTERNS"

for bucket in $BUCKETS; do
  BUCKETNAME=$(echo "${bucket}" | sed 's/gs:\/\/*//g' | sed 's/.$//')
  FILENAME="${BUCKETNAME}_${DATE}"

  # Exclude bucket if it matches the exclusion pattern
  if [[ -n "$EXCLUSION_PATTERN" && "$BUCKETNAME" == "$EXCLUSION_PATTERN" ]]; then
    echo "Excluding bucket '${BUCKETNAME}' due to EXCLUSION_PATTERN."
    continue
  fi

  match=false
  for pattern in "${PATTERNS[@]}"; do
    if [[ $BUCKETNAME == "$pattern" || $BUCKETNAME == *"${pattern#\*}" ]]; then
      match=true
      break
    fi
  done

  if [ "$match" = true ]; then
    if [[ "$(gsutil du -s "${bucket}")" == 0* ]]; then
      echo "Skipping empty bucket '${BUCKETNAME}'"
    else
      echo "Backing up bucket '${BUCKETNAME}'"
      gsutil -m cp -r "${bucket}" "/tmp/${DATE}"

      # Remove files that are too big, because they cause zip to fail!
      # http://infozip.sourceforge.net/FAQ.html#limits
      find "/tmp/${DATE}" -size +209715200c -exec rm {} \;

      zip -r9 "/tmp/${FILENAME}.zip" "/tmp/${DATE}/${BUCKETNAME}"
      openssl aes-256-cbc -md md5 -in "/tmp/${FILENAME}.zip" -out "/tmp/${FILENAME}.zip.encrypted" -pass "pass:${B2_ENCRYPTION_KEY}"
      b2 file upload "${B2_BUCKET}" "/tmp/${FILENAME}.zip.encrypted" "${BUCKETNAME}/${FILENAME}.zip.encrypted"
      rm "/tmp/${FILENAME}".*
      rm -r "/tmp/${DATE}"/*
    fi
  fi
done

echo "Backup of cloud storage buckets completed!"
