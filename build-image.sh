#!/bin/bash
# Description: Build image and push to repository
# Maintainer: Mauro Cardillo
# DOCKER_HUB_USER and DOCKER_HUB_PASSWORD is user environment variable
source ./.env

BUILD_DATE=$(date +"%Y-%m-%d")
IMAGE=maurosoft1973/alpine-mariadb

#The version of MariaDB is 
declare -A MARIADB_VERSIONS
MARIADB_VERSIONS["3.13"]="10.5.8-r0"
MARIADB_VERSIONS["3.12"]="10.4.17-r1"
MARIADB_VERSIONS["3.11"]="10.4.17-r1"
MARIADB_VERSIONS["3.10"]="10.3.27-r0"
MARIADB_VERSIONS["3.9"]="10.3.25-r0"
MARIADB_VERSIONS["3.8"]="10.2.32-r0"
MARIADB_VERSIONS["3.7"]="10.1.41-r0"

# Loop through arguments and process them
for arg in "$@"
do
    case $arg in
       -ar=*|--alpine-release=*)
        ALPINE_RELEASE="${arg#*=}"
        shift # Remove
        ;;
        -av=*|--alpine-version=*)
        ALPINE_VERSION="${arg#*=}"
        shift # Remove
        ;;
        -r=*|--release=*)
        RELEASE="${arg#*=}"
        shift # Remove
        ;;
        -h|--help)
        echo -e "usage "
        echo -e "$0 "
        echo -e "  -ar=|--alpine-release=${ALPINE_RELEASE} -> alpine release"
        echo -e "  -av=|--alpine-version=${ALPINE_VERSION} -> alpine version"
        echo -e "  -r=|--release=${RELEASE} -> release of image"
        echo -e ""
        echo -e "  Version of MariaDB installed is ${MARIADB_VERSIONS["$ALPINE_RELEASE"]}"
        exit 0
        ;;
    esac
done

MARIADB_VERSION=${MARIADB_VERSIONS["$ALPINE_RELEASE"]}

echo "# Image               : ${IMAGE}"
echo "# Image Release       : ${RELEASE}"
echo "# Build Date          : ${BUILD_DATE}"
echo "# Alpine Release      : ${ALPINE_RELEASE}"
echo "# Alpine Version      : ${ALPINE_VERSION}"
echo "# MariaDB Version     : ${MARIADB_VERSION}"

if [ "$RELEASE" == "TEST" ]; then
    echo "Remove image ${IMAGE}:test"
    docker rmi -f ${IMAGE}:test > /dev/null 2>&1

    echo "Remove image ${IMAGE}:${MARIADB_VERSION}-test"
    docker rmi -f ${IMAGE}:${MARIADB_VERSION}-test > /dev/null 2>&1

    echo "Build Image: ${IMAGE} -> ${RELEASE}"
    docker build --build-arg BUILD_DATE=${BUILD_DATE} --build-arg ALPINE_RELEASE=${ALPINE_RELEASE} --build-arg ALPINE_VERSION=${ALPINE_VERSION} --build-arg MARIADB_VERSION=${MARIADB_VERSION} -t ${IMAGE}:test -t ${IMAGE}:${MARIADB_VERSION}-test -f ./Dockerfile .

    echo "Login Docker HUB"
    echo "$DOCKER_HUB_PASSWORD" | docker login -u "$DOCKER_HUB_USER" --password-stdin

    echo "Push Image -> ${IMAGE}:test"
    docker push ${IMAGE}:test

    echo "Push Image -> ${IMAGE}:${MARIADB_VERSION}-test"
    docker push ${IMAGE}:${MARIADB_VERSION}-test
elif [ "$RELEASE" == "CURRENT" ]; then
    echo "Remove image ${IMAGE}:${MARIADB_VERSION}"
    docker rmi -f ${IMAGE}:${MARIADB_VERSION} > /dev/null 2>&1

    echo "Remove image ${IMAGE}:${MARIADB_VERSION}-amd64"
    docker rmi -f ${IMAGE}:${MARIADB_VERSION}-amd64 > /dev/null 2>&1

    echo "Remove image ${IMAGE}:${MARIADB_VERSION}-x86_64"
    docker rmi -f ${IMAGE}:${MARIADB_VERSION}-x86_64 > /dev/null 2>&1

    echo "Build Image: ${IMAGE}:${MARIADB_VERSION} -> ${RELEASE}"
    docker build --build-arg BUILD_DATE=${BUILD_DATE} --build-arg ALPINE_RELEASE=${ALPINE_RELEASE} --build-arg ALPINE_VERSION=${ALPINE_VERSION} --build-arg MARIADB_VERSION=${MARIADB_VERSION} -t ${IMAGE}:${MARIADB_VERSION} -t ${IMAGE}:${MARIADB_VERSION}-amd64 -t ${IMAGE}:${MARIADB_VERSION}-x86_64 -f ./Dockerfile .

    echo "Login Docker HUB"
    echo "$DOCKER_HUB_PASSWORD" | docker login -u "$DOCKER_HUB_USER" --password-stdin

    echo "Push Image -> ${IMAGE}:${MARIADB_VERSION}"
    docker push ${IMAGE}:${MARIADB_VERSION}

    echo "Push Image -> ${IMAGE}:${MARIADB_VERSION}-amd64"
    docker push ${IMAGE}:${MARIADB_VERSION}-amd64

    echo "Push Image -> ${IMAGE}:${MARIADB_VERSION}-x86_64"
    docker push ${IMAGE}:${MARIADB_VERSION}-x86_64
else
    echo "Remove image ${IMAGE}:latest"
    docker rmi -f ${IMAGE} > /dev/null 2>&1

    echo "Remove image ${IMAGE}:amd64"
    docker rmi -f ${IMAGE}:amd64 > /dev/null 2>&1

    echo "Remove image ${IMAGE}:x86_64"
    docker rmi -f ${IMAGE}:x86_64 > /dev/null 2>&1

    echo "Build Image: ${IMAGE} -> ${RELEASE}"
    docker build --build-arg BUILD_DATE=${BUILD_DATE} --build-arg ALPINE_RELEASE=${ALPINE_RELEASE} --build-arg ALPINE_VERSION=${ALPINE_VERSION} --build-arg MARIADB_VERSION=${MARIADB_VERSION} -t ${IMAGE}:latest -t ${IMAGE}:amd64 -t ${IMAGE}:x86_64 -f ./Dockerfile .

    echo "Login Docker HUB"
    echo "$DOCKER_HUB_PASSWORD" | docker login -u "$DOCKER_HUB_USER" --password-stdin

    echo "Push Image -> ${IMAGE}:latest"
    docker push ${IMAGE}:latest

    echo "Push Image -> ${IMAGE}:amd64"
    docker push ${IMAGE}:amd64

    echo "Push Image -> ${IMAGE}:x86_64"
    docker push ${IMAGE}:x86_64
fi
