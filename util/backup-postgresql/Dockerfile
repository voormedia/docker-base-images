# TODO: Replace all of this (until "---") with the following:
# FROM voormedia/backup-base:latest
FROM docker:27.3.1 as static-docker-source

FROM voormedia/base:edge

ENV CLOUD_SDK_VERSION=500.0.0
ENV ARCH=x86_64
ENV PATH /google-cloud-sdk/bin:$PATH
COPY --from=static-docker-source /usr/local/bin/docker /usr/local/bin/docker
COPY --from=static-docker-source /usr/local/libexec/docker/cli-plugins/docker-buildx /usr/local/libexec/docker/cli-plugins/docker-buildx
RUN addgroup -g 1000 -S cloudsdk && \
    adduser -u 1000 -S cloudsdk -G cloudsdk
RUN apk --no-cache upgrade && apk --no-cache add \
        curl \
        python3 \
        py3-crcmod \
        py3-openssl \
        bash \
        libc6-compat \
        openssh-client \
        git \
        gnupg \
    && curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-${CLOUD_SDK_VERSION}-linux-${ARCH}.tar.gz && \
    tar xzf google-cloud-cli-${CLOUD_SDK_VERSION}-linux-${ARCH}.tar.gz && \
    rm google-cloud-cli-${CLOUD_SDK_VERSION}-linux-${ARCH}.tar.gz && \
    mv google-cloud-sdk /google-cloud-sdk && \
    gcloud config set core/disable_usage_reporting true && \
    gcloud config set component_manager/disable_update_check true && \
    gcloud config set metrics/environment docker_image_alpine && \
    gcloud --version
RUN git config --system credential.'https://source.developers.google.com'.helper gcloud.sh
VOLUME ["/root/.config"]

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

# ---
RUN \
  apk add --no-cache \
  postgresql18-client

COPY backup-postgresql.sh /srv

RUN chmod +x /srv/backup-postgresql.sh

ENTRYPOINT ["/srv/backup-postgresql.sh"]
