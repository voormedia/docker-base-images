FROM voormedia/base-dev
MAINTAINER Rolf Timmermans <rolftimmermans@voormedia.com>

# Install yarn (npm replacement)
RUN cd /usr/local && \
 wget https://github.com/yarnpkg/yarn/releases/download/v0.16.1/yarn-v0.16.1.tar.gz -qO yarn.tar.gz && \
 tar zxf yarn.tar.gz --strip-components=1

ENV \
 PATH="/usr/local/bin:$PATH"
