ARG version
FROM ruby:${version}-buster

RUN apt-get update -qy && \
apt-get install -y nodejs postgresql-client yarnpkg

RUN ln -s /usr/bin/yarnpkg /usr/bin/yarn
