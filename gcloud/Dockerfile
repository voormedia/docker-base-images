ARG version
FROM voormedia/base:${version}

ENV \
PATH="/opt/google-cloud-sdk/bin:$PATH"

# Install build essentials
RUN \
apk add --no-cache \
python3 && \
cd /opt && \
wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-394.0.0-linux-x86_64.tar.gz && \
tar -xf google-cloud-cli-394.0.0-linux-x86_64.tar.gz && \
rm -rf google-cloud-cli-394.0.0-linux-x86_64.tar.gz && \
gcloud config set core/disable_usage_reporting true && \
gcloud config set component_manager/disable_update_check true && \
gcloud components install kubectl && \
gcloud auth configure-docker eu.gcr.io --quiet && \
gcloud auth configure-docker europe-west1-docker.pkg.dev --quiet
