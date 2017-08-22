FROM voormedia/base

# Install ElasticSearch
RUN apk add --no-cache \
elasticsearch && \
rm /etc/init.d/elasticsearch

COPY run.sh /

VOLUME /data

WORKDIR /data

ENTRYPOINT ["elasticsearch"]
