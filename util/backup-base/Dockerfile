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
# b2sdk package has a bad release, so we temporarily pin it to a specific version.
pip install 'b2==4.3.2' 'b2sdk>=2.9.3' --break-system-packages