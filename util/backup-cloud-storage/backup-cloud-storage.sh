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

if [ "${has_errors}" = true ]; then
  exit 1
fi

b2 account authorize

DATE=$(date +"%Y-%m-%d_%H:%M:%S")

mkdir "/tmp/${DATE}"
BUCKETS=`gsutil ls`

for bucket in $BUCKETS; do
  BUCKETNAME=$(echo "${bucket}" | sed 's/gs:\/\/*//g' | sed 's/.$//')
  FILENAME="${BUCKETNAME}_${DATE}"
  if [[ $bucket =~ "-prd/" ]]; then
    if [[ "$(gsutil du -s ${bucket})" == 0* ]]; then
      echo "Skipping empty bucket '${BUCKETNAME}'"
    else
      gsutil -m cp -r "${bucket}" "/tmp/${DATE}"

      # Remove files that are too big, because they cause zip to fail!
      # http://infozip.sourceforge.net/FAQ.html#limits
      find "/tmp/${DATE}" -size +209715200c -exec rm {} \;

      zip -r9 "/tmp/${FILENAME}".zip "/tmp/${DATE}/${BUCKETNAME}"
      openssl aes-256-cbc -md md5 -in "/tmp/${FILENAME}.zip" -out "/tmp/${FILENAME}.zip.encrypted" -pass "pass:${B2_ENCRYPTION_KEY}"
      b2 file upload "${B2_BUCKET}" "/tmp/${FILENAME}.zip.encrypted" "${BUCKETNAME}/${FILENAME}.zip.encrypted"
      rm "/tmp/${FILENAME}".*
      rm -r "/tmp/${DATE}"/*
    fi
  fi
done

echo "Backup of cloud storage buckets completed."
