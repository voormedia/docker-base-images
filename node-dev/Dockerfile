FROM voormedia/base-dev
MAINTAINER Rolf Timmermans <rolftimmermans@voormedia.com>

# Install yarn (npm replacement) - Make sure to use the release package
# download from Github as opposed to the SOURCE package.
RUN cd /usr/local && \
 wget https://github.com/yarnpkg/yarn/releases/download/v0.23.2/yarn-v0.23.2.tar.gz -qO yarn.tar.gz && \
 tar zxf yarn.tar.gz --strip-components=1

ENV \
 PATH="/usr/local/bin:$PATH"
