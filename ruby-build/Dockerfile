ARG version
FROM voormedia/build:${version}

# Just like the regular Ruby container, but install a few very common
# dev dependencies.
RUN \
apk add --no-cache \
libffi-dev \
ruby \
ruby-dev \
ruby-bigdecimal \
ruby-bundler \
ruby-irb \
zlib-dev \
# Do not install gem documentation.
&& echo "gem: --no-rdoc --no-ri" > /etc/gemrc \
# Use https URLs for Github so bundle will be happier.
&& bundle config --global github.https true \
# Don't complain about running as root.
&& bundle config --global silence_root_warning true
