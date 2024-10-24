FROM voormedia/backup-base:latest

RUN \
apk add --no-cache \
git \
github-cli

COPY backup-github.sh /srv

ENTRYPOINT ["/srv/backup-github.sh"]
