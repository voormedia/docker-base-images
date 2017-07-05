FROM voormedia/base-dev

# Install yarn (npm replacement) - Make sure to use the release package
# download from Github as opposed to the SOURCE package.
RUN cd /usr/local && \
wget https://github.com/yarnpkg/yarn/releases/download/v0.26.0/yarn-v0.26.0.tar.gz -qO yarn.tar.gz && \
tar zxf yarn.tar.gz --strip-components=1 && \

yarn global add node-gyp

ENV \
PATH="/usr/local/bin:$PATH"
