ARG version=edge
FROM alpine:${version}
ARG version

LABEL \
maintainer="Rolf Timmermans <rolftimmermans@voormedia.com>" \
base="alpine:${version}"

# Set timezone to UTC for everything. Also see:
# https://blog.packagecloud.io/eng/2017/02/21/set-environment-variable-save-thousands-of-system-calls/
ENV \
TZ="UTC"

# Apply latest security patches.
RUN apk upgrade --no-cache

WORKDIR /srv
