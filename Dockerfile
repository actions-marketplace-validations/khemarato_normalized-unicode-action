FROM alpine:latest

RUN apk add --no-cache --no-progress icu bash git

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
