FROM voormedia/base-dev

# Install yarn (package manager).
RUN apk add --no-cache \
yarn && \
yarn global add node-gyp

ENV \
PATH="/usr/local/bin:$PATH"
