ARG version=edge
FROM voormedia/base:${version}

RUN \
apk add --no-cache \
openssl \
ruby \
yaml \
mimalloc2 \
patchelf \
# Patch the Ruby binary to use mimalloc.
&& patchelf --add-needed libmimalloc.so.2 /usr/bin/ruby \
# Remove patchelf.
&& apk del patchelf \
# Do not install gem documentation.
&& echo "gem: --no-rdoc --no-ri" > /etc/gemrc \
# Update RubyGems to the latest version.
&& gem update --system \
# Install latest Bundler.
&& gem install bundler \
# Use https URLs for Github so bundle will be happier.
&& bundle config --global github.https true \
# Don't complain about running as root.
&& bundle config --global silence_root_warning true

# Tell mimallloc to use large (2MB+) OS pages if possible.
ENV \
MIMALLOC_ALLOW_LARGE_OS_PAGES=1
