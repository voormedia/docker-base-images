FROM voormedia/base

# Install build essentials
RUN apk add --no-cache \
autoconf \
automake \
binutils-gold \
clang \
gcc \
libc-dev \
libtool \
libunwind-dev \
linux-headers \
llvm \
make \
nasm \
nodejs \
cmake \
git \
openssh-client \
python3

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
LDFLAGS="-nostdlib -Wl,--no-posix-fallocate -Wl,-dynamic-linker=/usr/lib/libc.so"

# /usr/lib/crt1.o /usr/lib/crti.o /usr/lib/crtn.o
