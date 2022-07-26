ARG version
FROM voormedia/base:${version}

# Install build essentials
RUN \
apk add --no-cache \
python3

RUN \
cd /opt && \
wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-394.0.0-linux-x86_64.tar.gz && \
tar -xf google-cloud-cli-394.0.0-linux-x86_64.tar.gz && \
rm -rf google-cloud-cli-394.0.0-linux-x86_64.tar.gz && \
./google-cloud-sdk/install.sh --additional-components kubectl && \
./google-cloud-sdk/bin/gcloud components update

ENV \
PATH="/opt/google-cloud-sdk/bin:$PATH"
