FROM voormedia/backup-base:latest

RUN \
  apk add --no-cache \
  postgresql18-client

COPY backup-postgresql.sh /srv

RUN chmod +x /srv/backup-postgresql.sh

ENTRYPOINT ["/srv/backup-postgresql.sh"]
