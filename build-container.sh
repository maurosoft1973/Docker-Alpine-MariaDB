#!/bin/bash
# Description: Script for alpine mariadb container
# Maintainer: Mauro Cardillo
#
echo "Get Remote Environment Variable"
wget -q "https://gitlab.com/maurosoft1973-docker/alpine-variable/-/raw/master/.env" -O ./.env
source ./.env

echo "Get Remote Settings"
wget -q "https://gitlab.com/maurosoft1973-docker/alpine-variable/-/raw/master/settings.sh" -O ./settings.sh
chmod +x ./settings.sh
source ./settings.sh

# Default values of arguments
IMAGE=maurosoft1973/alpine-mariadb
IMAGE_TAG=latest
CONTAINER=alpine-mariadb
LC_ALL=it_IT.UTF-8
TIMEZONE=Europe/Rome
IP=0.0.0.0
PORT=33060
MYSQL_DATA=/var/database/mariadb-dbtest
MYSQL_DATABASE=dbtest
MYSQL_DATA_USER=root
MYSQL_DATA_USER_UID=0
MYSQL_DATA_GROUP=vboxsf
MYSQL_DATA_GROUP_UID=998
MYSQL_USER=test
MYSQL_PASSWORD=test
MYSQL_ROOT_PASSWORD=root

# Loop through arguments and process them
for arg in "$@"
do
    case $arg in
        -it=*|--image-tag=*)
        IMAGE_TAG="${arg#*=}"
        shift # Remove
        ;;
        -cn=*|--container=*)
        CONTAINER="${arg#*=}"
        shift # Remove
        ;;
        -cl=*|--lc_all=*)
        LC_ALL="${arg#*=}"
        shift # Remove
        ;;
        -ct=*|--timezone=*)
        TIMEZONE="${arg#*=}"
        shift # Remove
        ;;
        -ci=*|--ip=*)
        IP="${arg#*=}"
        shift # Remove
        ;;
        -cp=*|--port=*)
        PORT="${arg#*=}"
        shift # Remove
        ;;
        -dd=*|--data=*)
        MYSQL_DATA="${arg#*=}"
        shift # Remove
        ;;
        -db=*|--database=*)
        MYSQL_DATABASE="${arg#*=}"
        shift # Remove
        ;;
        -us=*|--user=*)
        MYSQL_USER="${arg#*=}"
        shift # Remove
        ;;
        -up=*|--password=*)
        MYSQL_PASSWORD="${arg#*=}"
        shift # Remove
        ;;
        -rp=*|--rootpassword=*)
        MYSQL_ROOT_PASSWORD="${arg#*=}"
        shift # Remove
        ;;
        -h|--help)
        echo -e "usage "
        echo -e "$0 "
        echo -e "  -it=|--image-tag -> ${IMAGE}:${IMAGE_TAG} (image with tag)"
        echo -e "  -cn=|--container -> ${CONTAINER} (container name)"
        echo -e "  -cl=|--lc_all -> ${LC_ALL} (container locale)"
        echo -e "  -ct=|--timezone -> ${TIMEZONE} (container timezone)"
        echo -e "  -ci=|--ip -> ${IP} (container ip)"
        echo -e "  -cp=|--port -> ${PORT}:3306 (port listen)"
        echo -e "  -dd=|--data-directory -> ${MYSQL_DATA} (path of data)"
        echo -e "  -du=|--data-user -> ${MYSQL_DATA_USER} (mysql owner data directory)"
        echo -e "  -dui=|--data-user-uid -> ${MYSQL_DATA_USER_UID} (mysql owner data directory uid)"
        echo -e "  -dg=|--data-group -> ${MYSQL_DATA_GROUP} (mysql group data directory)"
        echo -e "  -dgi=|--data-group-gid -> ${MYSQL_DATA_GROUP_UID} (mysql group data directory gid)"
        echo -e "  -db=|--database -> ${MYSQL_DATABASE} (name of database)"
        echo -e "  -us=|--user -> ${MYSQL_USER} (mysql user)"
        echo -e "  -up=|--password -> ${MYSQL_PASSWORD} (mysql password)"
        echo -e "  -rp=|--root_password -> ${MYSQL_ROOT_PASSWORD} (mysql root password)"
        exit 0
        ;;
    esac
done

echo "# Image                   : ${IMAGE}:${IMAGE_TAG}"
echo "# Container Name          : ${CONTAINER}"
echo "# Container Locale        : ${LC_ALL}"
echo "# Container Timezone      : ${TIMEZONE}"
echo "# Container IP            : $IP"
echo "# Container Port Listen   : ${PORT}"
echo "# MYSQL Data              : ${MYSQL_DATA}"
echo "# MYSQL Data User         : ${MYSQL_DATA_USER}"
echo "# MYSQL Data User UID     : ${MYSQL_DATA_USER_UID}"
echo "# MYSQL Data Group        : ${MYSQL_DATA_GROUP}"
echo "# MYSQL Data Group UID    : ${MYSQL_DATA_GROUP_UID}"
echo "# MYSQL Database          : ${MYSQL_DATABASE}"
echo "# MYSQL User              : ${MYSQL_USER}"
echo "# MYSQL Password          : ${MYSQL_PASSWORD}"
echo "# MYSQL Root Password     : ${MYSQL_ROOT_PASSWORD}"

echo -e "Check if container ${CONTAINER} exist"
CHECK=$(docker container ps -a | grep ${CONTAINER} | wc -l)
if [ ${CHECK} == 1 ]; then
    echo -e "Stop Container -> ${CONTAINER}"
    docker stop ${CONTAINER} > /dev/null

    echo -e "Remove Container -> ${CONTAINER}"
    docker container rm ${CONTAINER} > /dev/null
else 
    echo -e "The container ${CONTAINER} not exist"
fi

echo -e "Check port ${PORT}"
CHECK=$(netstat -naltp | grep ${PORT} | wc -l)
if [ ${CHECK} == 1 ]; then
    echo -e "The port ${PORT} is in use. Abort"
    exit 0
fi

echo -e "Create and run container"
docker run -idt --name ${CONTAINER} -p ${IP}:${PORT}:3306 -v ${MYSQL_DATA}:/var/lib/mysql -v $(pwd)/pre-init.d:/scripts/pre-init.d -e LC_ALL=${LC_ALL} -e TIMEZONE=${TIMEZONE} -e MYSQL_DATABASE=${MYSQL_DATABASE} -e MYSQL_DATA_USER=${MYSQL_DATA_USER} -e MYSQL_DATA_USER_UID=${MYSQL_DATA_USER_UID} -e MYSQL_DATA_GROUP=${MYSQL_DATA_GROUP} -e MYSQL_DATA_GROUP_UID=${MYSQL_DATA_GROUP_UID} -e MYSQL_USER=${MYSQL_USER} -e MYSQL_PASSWORD=${MYSQL_PASSWORD} -e MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD} ${IMAGE}:${IMAGE_TAG}

echo -e "Sleep 5 second"
sleep 5

IP=$(docker exec -it ${CONTAINER} /sbin/ip route | grep "src" | awk '{print $7}')
echo -e "IP Address is: ${IP}";

echo -e ""
echo -e "Environment variable";
docker exec -it ${CONTAINER} env

echo -e ""
echo -e "Test Locale (date)";
docker exec -it ${CONTAINER} date

echo -e ""
echo -e "Check Connection to DB"
docker exec -it $CONTAINER mysql -u${MYSQL_USER} -p${MYSQL_PASSWORD} ${MYSQL_DATABASE} -e "SELECT NOW()"

echo -e ""
echo -e "Container Logs"
docker logs ${CONTAINER}

rm -rf ./.env
rm -rf ./settings.sh
