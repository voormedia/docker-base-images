ARG version
FROM voormedia/base:${version}

LABEL \
role="build"

# Install build essentials
# NOTES
#   - wget & ca-certificates are needed because busybox default gives an error:
#       wget: can't execute 'ssl_helper': No such file or directory
#       wget: error getting response: Connection reset by peer
#   - python2 is used for gyp and node-gyp.
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
python2 \
rust \
valgrind

# Silence some git warnings
RUN \
git config --global advice.detachedHead false
