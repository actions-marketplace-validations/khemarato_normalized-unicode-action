FROM ubuntu:latest

RUN apt install libicu-dev

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
