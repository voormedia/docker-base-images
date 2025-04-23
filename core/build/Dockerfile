ARG version=edge
FROM voormedia/base:${version}

LABEL \
role="build"

# Install build essentials
RUN \
apk add --no-cache \
autoconf \
automake \
build-base \
chromium-chromedriver \
cargo \
file \
gdb \
libtool \
linux-headers \
nasm \
nodejs \
yarn \
cmake \
git \
openssh-client \
mysql-client \
mariadb-dev \
postgresql-client \
python3 \
rust \
valgrind \
postgresql-dev \
tzdata \
# Silence some git warnings
&& git config --global advice.detachedHead false

# Install script to run commands (used in CI).
COPY run.sh /usr/local/bin/

# Set chromedriver path for webdriver gem.
ENV \
WD_CHROME_PATH=/usr/bin/chromedriver

# By default, run all commands given as arguments within a shell (used in CI).
ENTRYPOINT ["/usr/local/bin/run.sh"]
