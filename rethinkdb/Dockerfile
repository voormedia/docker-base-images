FROM voormedia/base
MAINTAINER Rolf Timmermans <rolftimmermans@voormedia.com>

# Install RethinkDB
# wget/ca-certificates temporarily required because busybox's wget + ssl is
# broken: https://github.com/gliderlabs/docker-alpine/issues/188
# jq needed for startup magic
RUN echo @testing http://nl.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories && \
 apk add --no-cache \
 wget \
 ca-certificates \
 jq \
 rethinkdb@testing && \
 rm /etc/init.d/rethinkdb

VOLUME /data

WORKDIR /data

ENTRYPOINT ["rethinkdb"]
