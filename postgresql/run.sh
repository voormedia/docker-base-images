#!/bin/sh
# Based on:
# https://github.com/kiasaki/docker-alpine-postgres/blob/master/docker-entrypoint.sh

if [ ! -d "${PGDATA}" ]; then
  mkdir -p "${PGDATA}"
  initdb
  sed -ri "s/^#(listen_addresses\s*=\s*)\S+/\1'*'/" "${PGDATA}/postgresql.conf"

  if [ "${PGDB}" != 'postgres' ]; then
    echo "CREATE DATABASE ${PGDB};" | postgres --single -jE
  fi

  if [ "${PGUSER}" != 'postgres' ]; then
    echo "CREATE USER ${PGUSER} WITH SUPERUSER;" | postgres --single -jE
  else
    echo "ALTER USER ${PGUSER} WITH SUPERUSER;" | postgres --single -jE
  fi

  { echo; echo "host all all 0.0.0.0/0 trust"; } >> "${PGDATA}/pg_hba.conf"
fi

chmod -R o-rwx,g-rwx "${PGDATA}"
exec postgres "$@"
