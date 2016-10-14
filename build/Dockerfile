FROM alpine:edge
MAINTAINER Rolf Timmermans <rolftimmermans@voormedia.com>

# Install build essentials
RUN apk add --no-cache \
  binutils-gold \
  clang \
  cmake \
  g++ \
  git \
  llvm \
  make \
  musl-dev \
  openssh-client

# Use gold linker
RUN ln -s "$(which ld.gold)" /usr/local/bin/ld

# Set some useful default compile flags
ENV CFLAGS -Wall -Werror -flto
ENV CXXFLAGS -Wall -Werror -std=c++14 -flto

# Use clang by default
ENV CC /usr/bin/clang
ENV CXX /usr/bin/clang++

VOLUME /build
VOLUME /build/src
VOLUME /build/dist

WORKDIR /build
