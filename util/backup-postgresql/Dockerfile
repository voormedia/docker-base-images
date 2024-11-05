FROM voormedia/backup-base:latest

RUN \
  apk add --no-cache \
  postgresql17-client

COPY backup-postgresql.sh /srv

ENTRYPOINT ["/srv/backup-postgresql.sh"]
