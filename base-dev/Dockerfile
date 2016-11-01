FROM voormedia/base
MAINTAINER Rolf Timmermans <rolftimmermans@voormedia.com>

# Install build essentials
RUN apk add --no-cache \
 autoconf \
 automake \
 binutils-gold \
 build-base \
 libtool \
 libunwind-dev \
 linux-headers \
 nasm \
 nodejs \
 cmake \
 git \
 openssh-client \
 python

# Use gold linker
RUN \
 ln -f /usr/x86_64-alpine-linux-musl/bin/ld.gold /usr/x86_64-alpine-linux-musl/bin/ld && \
 ln -f /usr/x86_64-alpine-linux-musl/bin/ld.gold /usr/bin/ld

# Silence some git warnings
RUN \
 git config --global advice.detachedHead false

# Set some useful default compile flags
ENV \
 CFLAGS="-Wall -Werror" \
 CXXFLAGS="-Wall -Werror" \
 LDFLAGS="-Wl,--no-posix-fallocate"

VOLUME /workspace

WORKDIR /workspace
