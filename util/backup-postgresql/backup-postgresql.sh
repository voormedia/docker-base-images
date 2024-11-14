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

if [ -z "${BACKUP_PATTERNS}" ]; then
  echo "BACKUP_PATTERNS is not set."
  has_errors=true
fi

if [ "${has_errors}" = true ]; then
  exit 1
fi

b2 account authorize

DATE=$(date +"%Y-%m-%d_%H:%M:%S")

IFS=',' read -r -a PATTERNS <<< "$BACKUP_PATTERNS"

DATABASES=$(psql -tA "dbname=postgres" -c 'SELECT datname FROM pg_database' | grep -v -e '^$')

for database in $DATABASES; do
  FILENAME="${database}_${DATE}"

  match=false
  for pattern in "${PATTERNS[@]}"; do
    if [[ $database == "$pattern" || $database == *"${pattern#\*}" ]]; then
      match=true
      break
    fi
  done

  if [ "$match" = true ]; then
    echo "Backing up database '${database}'"
    pg_dump --format=plain --no-owner --no-acl --clean -c "${database}" > "/tmp/${FILENAME}.sql"
    openssl aes-256-cbc -md md5 -in "/tmp/${FILENAME}.sql" -out "/tmp/${FILENAME}.sql.encrypted" -pass "pass:${B2_ENCRYPTION_KEY}"
    b2 file upload "${B2_BUCKET}" "/tmp/${FILENAME}.sql.encrypted" "${database}/${FILENAME}.sql.encrypted"
    rm "/tmp/${FILENAME}".*
  else
    echo "Database '${database}' does not match any pattern. Skipping..."
  fi
done

echo "Backup of PostgreSQL databases in this instance completed!"
