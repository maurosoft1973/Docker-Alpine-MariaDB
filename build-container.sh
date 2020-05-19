#!/bin/bash
# Description: Script for mysql container
# Maintainer: Mauro Cardillo
#

# Default values of arguments
IMAGE=maurosoft1973/alpine-mariadb:test
CONTAINER=mysql-test
LC_ALL=it_IT.UTF-8
TIMEZONE=Europe/Rome
IP=0.0.0.0
PORT=33060
MYSQL_DATA=/var/lib/mysql-test
MYSQL_DATABASE=dbtest
MYSQL_USER=test
MYSQL_PASSWORD=test
MYSQL_ROOT_PASSWORD=root

# Loop through arguments and process them
for arg in "$@"
do
    case $arg in
		-c=*|--container=*)
        CONTAINER="${arg#*=}"
        shift # Remove
        ;;
        -l=*|--lc_all=*)
        LC_ALL="${arg#*=}"
        shift # Remove
        ;;
        -t=*|--timezone=*)
        TIMEZONE="${arg#*=}"
        shift # Remove
        ;;
        -i=*|--ip=*)
        IP="${arg#*=}"
        shift # Remove
        ;;
        -pi=*|--portin=*)
        PORT_IN="${arg#*=}"
        shift # Remove
        ;;
		-d=*|--data=*)
        MYSQL_DATA="${arg#*=}"
        shift # Remove
        ;;
		-db=*|--database=*)
        MYSQL_DATABASE="${arg#*=}"
        shift # Remove
        ;;
		-u=*|--user=*)
        MYSQL_USER="${arg#*=}"
        shift # Remove
        ;;
		-p=*|--password=*)
        MYSQL_PASSWORD="${arg#*=}"
        shift # Remove
        ;;
		-r=*|--rootpassword=*)
        MYSQL_ROOT_PASSWORD="${arg#*=}"
        shift # Remove
        ;;
        -h|--help)
        echo -e "usage "
        echo -e "$0 "
		echo -e "  -c=|--container -> ${CONTAINER} (name of container)"
        echo -e "  -l=|--lc_all=${LC_ALL} -> locale"
        echo -e "  -t=|--timezone=${TIMEZONE} -> timezone"
		echo -e "  -i=|--ip -> ${IP} (address ip listen)"
		echo -e "  -p=|--port -> ${PORT} (port listen)"
		echo -e "  -d=|--data -> ${MYSQL_DATA} (path of data)"
		echo -e "  -n=|--database -> ${MYSQL_DATABASE} (name of database)"
		echo -e "  -u=|--user -> ${MYSQL_USER} (mysql user)"
		echo -e "  -p=|--password -> ${MYSQL_PASSWORD} (mysql password)"
		echo -e "  -r=|--rootpassword -> ${MYSQL_ROOT_PASSWORD} (mysql root password)"
        exit 0
		;;
    esac
done

echo "# Image               : ${IMAGE}"
echo "# Container Name      : ${CONTAINER}"
echo "# Locale              : ${LC_ALL}"
echo "# Timezone            : ${TIMEZONE}"
echo "# IP                  : ${IP}"
echo "# PORT                : ${PORT}"
echo "# MYSQL_DATA          : ${MYSQL_DATA}"
echo "# MYSQL_DATABASE      : ${MYSQL_DATABASE}"
echo "# MYSQL_USER          : ${MYSQL_USER}"
echo "# MYSQL_PASSWORD      : ${MYSQL_PASSWORD}"
echo "# MYSQL_ROOT_PASSWORD : ${MYSQL_ROOT_PASSWORD}"

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
docker run -idt --name ${CONTAINER} -p ${IP}:${PORT}:3306 -v ${MYSQL_DATA}:/var/lib/mysql -e LC_ALL=${LC_ALL} -e TIMEZONE=${TIMEZONE} -e MYSQL_DATABASE=${MYSQL_DATABASE} -e MYSQL_USER=${MYSQL_USER} -e MYSQL_PASSWORD=${MYSQL_PASSWORD} -e MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD} ${IMAGE}

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
