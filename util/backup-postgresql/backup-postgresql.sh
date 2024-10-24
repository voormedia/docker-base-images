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

if [ -z "${B2_ACCOUNT_ID}" ]; then
  echo "B2_ACCOUNT_ID is not set."
  has_errors=true
fi

if [ -z "${B2_APPLICATION_KEY}" ]; then
  echo "B2_APPLICATION_KEY is not set."
  has_errors=true
fi

if [ -z "${PGHOST}" ]; then
  echo "PGHOST is not set."
  has_errors=true
fi

if [ -z "${PGUSER}" ]; then
  echo "PGUSER is not set."
  has_errors=true
fi

if [ -z "${PGPASSWORD}" ]; then
  echo "PGPASSWORD is not set."
  has_errors=true
fi

if [ "${has_errors}" = true ]; then
  exit 1
fi

b2 authorize_account

DATE=$(date +"%Y-%m-%d_%H:%M:%S")

DATABASES=`psql "dbname=postgres" -c 'SELECT datname from pg_database' | sed -n '2!p'`
for database in $DATABASES; do
  echo $database
  FILENAME="${database}_${DATE}"
  if [[ $database =~ "-prd" ]]; then
    pg_dump --format=plain --no-owner --no-acl --clean -c "${database}" > "/tmp/${FILENAME}.sql"
    openssl aes-256-cbc -md md5 -in "/tmp/${FILENAME}.sql" -out "/tmp/${FILENAME}.sql.encrypted" -pass "pass:${B2_ENCRYPTION_KEY}"
    b2 upload_file "${B2_BUCKET}" "/tmp/${FILENAME}.sql.encrypted" "${database}/${FILENAME}.sql.encrypted"
    rm "/tmp/${FILENAME}".*
  fi
done

echo "Backup of PostgreSQL databases completed."
