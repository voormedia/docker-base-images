FROM voormedia/base
MAINTAINER Rolf Timmermans <rolftimmermans@voormedia.com>

# Install build essentials
# NOTES
#   - wget & ca-certificates are needed because busybox default gives an error:
#       wget: can't execute 'ssl_helper': No such file or directory
#       wget: error getting response: Connection reset by peer
#   - python2 is used for gyp and node-gyp.
RUN apk add --no-cache \
 autoconf \
 automake \
 build-base \
 ca-certificates \
 gdb \
 libtool \
 libunwind-dev \
 linux-headers \
 nasm \
 nodejs \
 cmake \
 git \
 openssh-client \
 python2 \
 valgrind \
 wget

# Silence some git warnings
RUN \
 git config --global advice.detachedHead false

VOLUME /workspace

WORKDIR /workspace
