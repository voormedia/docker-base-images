FROM alpine:edge
MAINTAINER Rolf Timmermans <rolftimmermans@voormedia.com>

# Install Node.js
RUN apk add --no-cache \
  nodejs

# Install yarn (better npm replacement)
RUN cd /usr/local && \
  apk add --no-cache ca-certificates && \
  wget https://yarnpkg.com/latest.tar.gz -O yarn.tar.gz && \
  tar zxf yarn.tar.gz --strip-components=1 && \
  apk del ca-certificates

ENV PATH /usr/local/bin:$PATH

VOLUME /srv/app
WORKDIR /srv

ENTRYPOINT ["node"]
