ARG version=edge
FROM alpine:${version}
ARG version
ARG APK_CACHE_BUST=1

LABEL \
maintainer="Rolf Timmermans <rolftimmermans@voormedia.com>" \
base="alpine:${version}"

# Set timezone to UTC for everything. Also see:
# https://blog.packagecloud.io/eng/2017/02/21/set-environment-variable-save-thousands-of-system-calls/
ENV \
TZ="UTC"

# Apply latest security patches (APK_CACHE_BUST forces a real re-run daily).
RUN echo "cache bust: ${APK_CACHE_BUST}" && apk upgrade --no-cache

WORKDIR /srv
