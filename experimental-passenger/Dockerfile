ARG version
FROM voormedia/ruby-build:${version} AS build

# Based on: https://github.com/VocativOps/docker-alpine-nginx-passenger-node/blob/master/Dockerfile

ARG passenger_version=5.1.12

RUN \
apk add --no-cache \
curl-dev \
openssl-dev \
pcre-dev \
tar \
wget \
zlib-dev \

&& gem install rack \

&& wget -O - https://github.com/phusion/passenger/archive/release-${passenger_version}.tar.gz | tar -xzf - --strip-components=1 -C /usr/local \
&& export EXTRA_PRE_CFLAGS="-O" \
&& export EXTRA_PRE_CXXFLAGS="-O" \
&& export EXTRA_LDFLAGS="-lexecinfo" \

&& passenger-config compile-agent --auto --optimize \
&& passenger-config install-standalone-runtime --auto --url-root=fake --connect-timeout=1 \
&& passenger-config build-native-support \
&& passenger-config validate-install --auto



# FROM voormedia/ruby:${version}
#
# RUN \
# apk add --no-cache \
# openssl \
# pcre
#
# COPY --from=build \
# /usr/local/sbin/nginx \
# /usr/local/sbin/
#
#
# ENTRYPOINT ["nginx", "-g", "daemon off;"]
