FROM voormedia/backup-base:latest

COPY backup-cloud-storage.sh /srv

RUN chmod +x /srv/backup-cloud-storage.sh

ENTRYPOINT ["/srv/backup-cloud-storage.sh"]
