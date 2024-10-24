ARG version
FROM voormedia/base:${version}

RUN \
apk add --no-cache \
nodejs \
&& rm -rf /usr/lib/node_modules

ENTRYPOINT ["node"]
