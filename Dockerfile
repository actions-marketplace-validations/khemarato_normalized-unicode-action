FROM alpine:latest

RUN apk add --no-cache --no-progress icu

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
