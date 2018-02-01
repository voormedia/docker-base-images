ARG version
FROM voormedia/base:${version}

# Install RethinkDB
# wget/ca-certificates temporarily required because busybox's wget + ssl is
# broken: https://github.com/gliderlabs/docker-alpine/issues/188
# jq needed for startup magic
RUN \
apk add --no-cache \
wget \
ca-certificates \
jq \
rethinkdb \
&& rm /etc/init.d/rethinkdb

COPY run.sh /

VOLUME /data

WORKDIR /data

ENTRYPOINT ["/run.sh"]
