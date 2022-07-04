ARG version

# Image (NOT the Voormedia ruby image)
FROM ruby:${version}

RUN \
curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
apt-get update && \
apt-get install -y apt-transport-https \
  ca-certificates \
  curl \
  git \
  composer \
  freetds-bin \
  freetds-dev \
  php-curl \
  gnupg2 \
  openssh-client \
  nodejs \
  xvfb \
  g++ \
  qtbase5-dev \
  qtchooser \
  qt5-qmake \
  qtbase5-dev-tools \
  libqt5webkit5-dev \
  gstreamer1.0-plugins-base \
  gstreamer1.0-tools \
  gstreamer1.0-x \
  software-properties-common

RUN \
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
apt-key fingerprint 0EBFCD88 && \
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian \
  $(lsb_release -cs) \
  stable" && \
apt-get update && \
apt-get install -y docker-ce yarn

RUN \
cd ~ && \
curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-392.0.0-linux-x86_64.tar.gz && \
tar -xf google-cloud-cli-392.0.0-linux-x86_64.tar.gz && \
./google-cloud-sdk/install.sh --quiet && \
./google-cloud-sdk/bin/gcloud components install kubectl && \
ls -la && \
rm google-cloud-cli-392.0.0-linux-x86_64.tar.gz

ENV \
PATH="/root/google-cloud-sdk/bin:$PATH"

RUN \
docker-credential-gcloud configure-docker && \
gcloud auth configure-docker eu.gcr.io --quiet && \
gcloud auth configure-docker europe-west1-docker.pkg.dev --quiet

RUN mkdir /root/.kube

# Install Go for debugging
# RUN wget -c https://storage.googleapis.com/golang/go1.10.3.linux-amd64.tar.gz
# RUN tar -C /usr/local -xvzf go1.10.3.linux-amd64.tar.gz
# RUN mkdir -p ~/go/src/github.com/voormedia && cd ~/go/src/github.com/voormedia && git clone https://github.com/voormedia/kd.git

RUN curl -L $(curl -s https://api.github.com/repos/voormedia/kd/releases/latest \
  | grep browser_download_url \
  | grep linux_amd64 \
  | cut -d '"' -f 4) -o ~/kd \
  && chmod +x ~/kd
