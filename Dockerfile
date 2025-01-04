ARG DOCKER_ALPINE_VERSION

FROM maurosoft1973/alpine:$DOCKER_ALPINE_VERSION

ARG BUILD_DATE
ARG ALPINE_ARCHITECTURE
ARG ALPINE_RELEASE
ARG ALPINE_VERSION
ARG ALPINE_VERSION_DATE
ARG MARIADB_VERSION
ARG MARIADB_VERSION_DATE

LABEL \
    maintainer="Mauro Cardillo <mauro.cardillo@gmail.com>" \
    architecture="$ALPINE_ARCHITECTURE" \
    mariadb-version="$MARIADB_VERSION" \
    alpine-version="$ALPINE_VERSION" \
    build="$BUILD_DATE" \
    org.opencontainers.image.title="alpine-mariadb" \
    org.opencontainers.image.description="MariaDB Docker image running on Alpine Linux" \
    org.opencontainers.image.authors="Mauro Cardillo <mauro.cardillo@gmail.com>" \
    org.opencontainers.image.vendor="Mauro Cardillo" \
    org.opencontainers.image.version="v$MARIADB_VERSION" \
    org.opencontainers.image.url="https://hub.docker.com/r/maurosoft1973/alpine-mariadb/" \
    org.opencontainers.image.source="https://gitlab.com/maurosoft1973-docker/alpine-mariadb" \
    org.opencontainers.image.created=$BUILD_DATE

RUN \
    echo "" > /etc/apk/repositories && \
    echo "https://dl-cdn.alpinelinux.org/alpine/$ALPINE_RELEASE/main" >> /etc/apk/repositories && \
    echo "https://dl-cdn.alpinelinux.org/alpine/$ALPINE_RELEASE/community" >> /etc/apk/repositories && \
    apk update && \
    apk add --no-cache mariadb mariadb-client mariadb-server-utils pwgen && \
    mkdir /docker-entrypoint-initdb.d && \
    mkdir /scripts/pre-exec.d && \
    mkdir /scripts/pre-init.d && \
    rm -f /var/cache/apk/*

ADD files/run-alpine-mariadb.sh /scripts/run-alpine-mariadb.sh

RUN chmod -R 755 /scripts

EXPOSE 3306

VOLUME ["/var/lib/mysql"]
VOLUME ["/etc/my.cnf.d"]

ENTRYPOINT ["/scripts/run-alpine-mariadb.sh"]
