ARG version

# Build image
FROM google/cloud-sdk:alpine as builder

RUN gcloud components install docker-credential-gcr --quiet
RUN docker-credential-gcr version

# Image
FROM ruby:${version}

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get update
RUN apt-get install -y apt-transport-https \
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
  qt5-default \
  libqt5webkit5-dev \
  gstreamer1.0-plugins-base \
  gstreamer1.0-tools \
  gstreamer1.0-x \
  software-properties-common

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN apt-key fingerprint 0EBFCD88
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian \
  $(lsb_release -cs) \
  stable"
RUN apt-get update
RUN apt-get install -y docker-ce yarn

COPY --from=builder /google-cloud-sdk/bin/* /usr/local/bin/
RUN docker-credential-gcr configure-docker

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
