ARG version
FROM voormedia/base:${version}

RUN \
apk add --no-cache \
ruby \
ruby-bigdecimal \
ruby-bundler \
# Do not install gem documentation.
&& echo "gem: --no-rdoc --no-ri" > /etc/gemrc \
# Use https URLs for Github so bundle will be happier.
&& bundle config --global github.https true \
# Don't complain about running as root.
&& bundle config --global silence_root_warning true
