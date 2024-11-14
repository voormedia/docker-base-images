FROM voormedia/backup-base:latest

RUN apk add --no-cache \
    curl \
    chromium \
    chromium-chromedriver \
    python3 \
    py3-pip && \
    pip install selenium --break-system-packages

COPY backup-notion.sh /srv/backup-notion.sh
COPY retrieve_cookie.py /srv/retrieve_cookie.py

RUN chmod +x /srv/backup-notion.sh

# Entry point for the backup script
ENTRYPOINT ["/srv/backup-notion.sh"]