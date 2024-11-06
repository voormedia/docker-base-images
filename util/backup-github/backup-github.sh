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

if [ -z "${GITHUB_ACCOUNT}" ]; then
  echo "GITHUB_ACCOUNT is not set."
  has_errors=true
fi

if [ -z "${GITHUB_TOKEN}" ]; then
  echo "GITHUB_TOKEN is not set."
  has_errors=true
fi

if [ "${has_errors}" = true ]; then
  exit 1
fi

b2 account authorize
gh auth setup-git

DATE=$(date +"%Y-%m-%d_%H:%M:%S")
FILENAME="git_repositories_${DATE}"

mkdir "/tmp/${FILENAME}"
cd "/tmp/${FILENAME}"

REPOS=$(gh repo list "${GITHUB_ACCOUNT}" --source --limit 100000 --json name | jq -r -c '.[] | .name')

if [ -n "$REPOSITORY_PREFIX" ]; then
  echo "Filtering on repositories with prefix '${REPOSITORY_PREFIX}'."
fi

for REPO in $REPOS; do
  if [[ $NAME == "${REPOSITORY_PREFIX}"* ]]; then
    gh repo clone "${GITHUB_ACCOUNT}/${NAME}" -- --mirror
    cd "${NAME}.git"

    if [[ -n "$(git rev-list --branches)" ]]; then
      # Check if there are any commits.
      git bundle create "../${NAME}.pack" --all
      cd ..

      zip -r9 "/tmp/${FILENAME}/${NAME}.zip" "/tmp/${FILENAME}/${NAME}.pack"
      openssl aes-256-cbc -md md5 -in "/tmp/${FILENAME}/${NAME}.zip" -out "/tmp/${FILENAME}/${NAME}.zip.encrypted" -pass "pass:${B2_ENCRYPTION_KEY}"
      b2 file upload "${B2_BUCKET}" "/tmp/${FILENAME}/${NAME}.zip.encrypted" "${NAME}/${DATE}.zip.encrypted"
    else
      echo "Skipping empty repository ${NAME}."
      cd ..
    fi

    rm -rf "/tmp/${FILENAME}/${NAME}.git"
    rm -f "/tmp/${FILENAME}/${NAME}".*
  fi
done

echo "Backup of Git repositories completed."
