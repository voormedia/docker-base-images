ARG version=edge
FROM voormedia/build:${version}

RUN \
apk add --no-cache \
yarn \
&& rm -rf /usr/lib/node_modules \
&& yarn global add \
node-gyp

ENV \
PATH="/usr/local/bin:$PATH"
