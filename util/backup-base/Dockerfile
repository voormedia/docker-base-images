FROM voormedia/gcloud:latest

LABEL \
role="backup"

RUN \
apk add --no-cache \
openssl \
bash \
zip \
jq \
py3-pip && \
pip install b2 --break-system-packages
