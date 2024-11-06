FROM voormedia/backup-base:latest

RUN \
apk add --no-cache \
github-cli

COPY backup-github.sh /srv

RUN chmod +x /srv/backup-github.sh

ENTRYPOINT ["/srv/backup-github.sh"]
