FROM voormedia/gcloud:latest

RUN \
apk add --no-cache \
docker-cli-buildx \
libc6-compat && \
docker-credential-gcloud configure-docker && \
mkdir /root/.kube && \
wget $(wget https://api.github.com/repos/voormedia/kd/releases/latest -O - \
  | grep browser_download_url \
  | grep linux_amd64 \
  | cut -d '"' -f 4) -O /usr/local/bin/kd \
  && chmod +x /usr/local/bin/kd
