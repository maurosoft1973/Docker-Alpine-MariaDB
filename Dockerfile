FROM maurosoft1973/alpine:3.11.5-amd64

ARG BUILD_DATE

LABEL maintainer="Mauro Cardillo <mauro.cardillo@gmail.com>" \
    architecture="amd64/x86_64" \
    mariadb-version="10.4.12" \
    alpine-version="3.11.5" \
    build="03-Apr-2020" \
    org.opencontainers.image.title="alpine-mariadb" \
    org.opencontainers.image.description="MariaDB Docker image running on Alpine Linux" \
    org.opencontainers.image.authors="Mauro Cardillo <mauro.cardillo@gmail.com>" \
    org.opencontainers.image.vendor="Mauro Cardillo" \
    org.opencontainers.image.version="v10.4.12" \
    org.opencontainers.image.url="https://hub.docker.com/r/maurosoft1973/alpine-mariadb/" \
    org.opencontainers.image.source="https://github.com/maurosoft1973/alpine-mariadb" \
    org.opencontainers.image.created=$BUILD_DATE

RUN apk add --no-cache mariadb mariadb-client mariadb-server-utils pwgen && \
    rm -f /var/cache/apk/*

ADD files/run.sh /scripts/run.sh
RUN mkdir /docker-entrypoint-initdb.d && \
    mkdir /scripts/pre-exec.d && \
    mkdir /scripts/pre-init.d && \
    chmod -R 755 /scripts

EXPOSE 3306

VOLUME ["/var/lib/mysql"]

ENTRYPOINT ["/scripts/run.sh"]
