FROM voormedia/base

RUN apk add --no-cache \
postgresql \
postgresql-contrib && \
rm /etc/init.d/postgresql

COPY run.sh /

ENV \
LANG="en_US.utf8" \
PGDATA="/data/pg" \
PGDB="postgres" \
PGUSER="postgres"

RUN mkdir -p /run/postgresql && \
chown -R postgres:postgres /run/postgresql

USER postgres
VOLUME /data

WORKDIR /data

ENTRYPOINT ["/run.sh"]
