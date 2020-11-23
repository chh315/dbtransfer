FROM alpine:3.11

COPY entrypoint.sh /

RUN apk update \
    && apk add mysql-client \
    && rm -rf /var/cache/apk/* \
    && chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
