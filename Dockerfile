FROM ubuntu:latest

RUN apt-get install icu-devtools

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
