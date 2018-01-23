FROM voormedia/ruby-build:3.7 AS build

RUN \
apk add --no-cache \
postgresql-dev \
tzdata \
yarn

COPY Gemfile Gemfile.lock /srv/
RUN \
bundle install --frozen --no-cache --deployment --binstubs bin --without test development \
&& bundle

COPY package.json yarn.lock /srv/
RUN \
yarn install

COPY app/javascript /srv/app/javascript
COPY app/stylesheets /srv/app/stylesheets
COPY config /srv/config
COPY lib /srv/lib
COPY Rakefile .postcssrc.yml .babelrc /srv/

RUN \
bin/rake webpacker:compile RAILS_ENV=production



FROM voormedia/ruby:3.7

RUN \
apk add --no-cache \
libpq \
tzdata

COPY . /srv/
COPY --from=build /srv/.bundle /srv/.bundle
COPY --from=build /srv/Gemfile /srv/Gemfile
COPY --from=build /srv/vendor /srv/vendor
COPY --from=build /srv/bin /srv/bin
COPY --from=build /srv/public/packs /srv/public/packs

RUN bundle

ENTRYPOINT ["/srv/bin/puma", "--preload", "--prune-bundler"]
