ARG version
FROM voormedia/base:${version}

LABEL \
role="build"

# Install build essentials
RUN \
apk add --no-cache \
autoconf \
automake \
build-base \
cargo \
file \
gdb \
libtool \
linux-headers \
nasm \
nodejs \
cmake \
git \
openssh-client \
postgresql-client \
python3 \
rust \
valgrind

# Silence some git warnings
RUN \
git config --global advice.detachedHead false
