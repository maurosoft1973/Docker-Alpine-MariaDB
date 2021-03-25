#!/bin/sh

source /scripts/init-alpine.sh

MYSQL_DATA_USER=${MYSQL_DATA_USER:-"mysql"}
MYSQL_DATA_USER_UID=${MYSQL_DATA_USER_UID:-"100"}
MYSQL_DATA_GROUP=${MYSQL_DATA_GROUP:-"mysql"}
MYSQL_DATA_GROUP_UID=${MYSQL_DATA_GROUP_UID:-"101"}
MYSQL_DATABASE=${MYSQL_DATABASE:-""}
MYSQL_CHARSET=${MYSQL_CHARSET:-"utf8"}
MYSQL_COLLATION=${MYSQL_COLLATION:-"utf8_general_ci"}
MYSQL_USER=${MYSQL_USER:-""}
MYSQL_PASSWORD=${MYSQL_PASSWORD:-""}
MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD:-""}

echo "MYSQL_DATA_USER: ${MYSQL_DATA_USER}"
echo "MYSQL_DATA_USER_UID: ${MYSQL_DATA_USER_UID}"
echo "MYSQL_DATA_GROUP: ${MYSQL_DATA_GROUP}"
echo "MYSQL_DATA_GROUP_UID: ${MYSQL_DATA_GROUP_UID}"

#Create Group (if not exist)
CHECK=$(cat /etc/group | grep $MYSQL_DATA_GROUP | wc -l)
if [ ${CHECK} == 0 ]; then
    echo "Create group $MYSQL_DATA_GROUP with uid $MYSQL_DATA_GROUP_UID"
    addgroup -g ${MYSQL_DATA_GROUP_UID} ${MYSQL_DATA_GROUP}
else
    echo -e "Skipping,group $MYSQL_DATA_GROUP exist"
fi

#Create User (if not exist)
CHECK=$(cat /etc/passwd | grep $MYSQL_DATA_USER | wc -l)
if [ ${CHECK} == 0 ]; then
    echo "Create User $MYSQL_DATA_USER with uid $MYSQL_DATA_USER_UID"
    adduser -s /bin/false -H -u ${MYSQL_DATA_USER_UID} -D ${MYSQL_DATA_USER}
else
    echo -e "Skipping,user $MYSQL_DATA_USER exist"
fi

if [ "${MYSQL_DATA_USER}" != "mysql" ]; then
    echo "[mysqld]" >> /etc/my.cnf.d/mariadb-server.cnf
    #echo "innodb_flush_method=O_DIRECT" >> /etc/my.cnf.d/mariadb-server.cnf
    echo "innodb_use_native_aio=0" >> /etc/my.cnf.d/mariadb-server.cnf
fi

# execute any pre-init scripts
for i in /scripts/pre-init.d/*sh
do
    if [ -e "${i}" ]; then
        echo "[i] pre-init.d - processing $i"
        . "${i}"
    fi
done

if [ -d "/run/mysqld" ]; then
    echo "[i] mysqld already present, skipping creation"
    chown -R $MYSQL_DATA_USER:$MYSQL_DATA_GROUP /run/mysqld
else
    echo "[i] mysqld not found, creating...."
    mkdir -p /run/mysqld
    chown -R $MYSQL_DATA_USER:$MYSQL_DATA_GROUP /run/mysqld
fi

if [ -d /var/lib/mysql/mysql ]; then
    echo "[i] MySQL directory already present, skipping creation"
    chown -R $MYSQL_DATA_USER:$MYSQL_DATA_GROUP /var/lib/mysql
else
    echo "[i] MySQL data directory not found, creating initial DBs"

    chown -R $MYSQL_DATA_USER:$MYSQL_DATA_GROUP /var/lib/mysql

    mysql_install_db --user=$MYSQL_DATA_USER --ldata=/var/lib/mysql

    if [ "$MYSQL_ROOT_PASSWORD" = "" ]; then
        MYSQL_ROOT_PASSWORD=`pwgen -s 25 1`
        echo "[i] MySQL root Password: $MYSQL_ROOT_PASSWORD"
    fi

    tfile=`mktemp`
    if [ ! -f "$tfile" ]; then
        return 1
    fi

    cat << EOF > $tfile
USE mysql;
FLUSH PRIVILEGES ;
GRANT ALL ON *.* TO 'root'@'%' identified by '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION ;
GRANT ALL ON *.* TO 'root'@'localhost' identified by '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION ;
SET PASSWORD FOR 'root'@'localhost'=PASSWORD('${MYSQL_ROOT_PASSWORD}') ;
DROP DATABASE IF EXISTS test ;
FLUSH PRIVILEGES ;
EOF

    if [ "$MYSQL_DATABASE" != "" ]; then
        echo "[i] Creating database: $MYSQL_DATABASE"
        echo "[i] with character set [$MYSQL_CHARSET] and collation [$MYSQL_COLLATION]"

        echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\` CHARACTER SET $MYSQL_CHARSET COLLATE $MYSQL_COLLATION;" >> $tfile

        if [ "$MYSQL_USER" != "" ]; then
            echo "[i] Creating user: $MYSQL_USER with password $MYSQL_PASSWORD"
            echo "GRANT ALL PRIVILEGES ON \`$MYSQL_DATABASE\`.* TO \`$MYSQL_USER\`@\`localhost\` IDENTIFIED BY '$MYSQL_PASSWORD';" >> $tfile
            echo "GRANT ALL PRIVILEGES ON \`$MYSQL_DATABASE\`.* TO \`$MYSQL_USER\`@\`%\` IDENTIFIED BY '$MYSQL_PASSWORD';" >> $tfile
            echo "FLUSH PRIVILEGES ;" >> $tfile
        fi
    fi

    /usr/bin/mysqld --user=$MYSQL_DATA_USER --bootstrap --verbose=0 --skip-name-resolve --skip-networking=0 < $tfile

    rm -f $tfile

    for f in /docker-entrypoint-initdb.d/*; do
        case "$f" in
            *.sql)    echo "$0: running $f"; /usr/bin/mysqld --user=$MYSQL_DATA_USER --bootstrap --verbose=0 --skip-name-resolve --skip-networking=0 < "$f"; echo ;;
            *.sql.gz) echo "$0: running $f"; gunzip -c "$f" | /usr/bin/mysqld --user=mysql --bootstrap --verbose=0 --skip-name-resolve --skip-networking=0 < "$f"; echo ;;
            *)        echo "$0: ignoring or entrypoint initdb empty $f" ;;
        esac
        echo
    done

    echo
    echo 'MySQL init process done. Ready for start up.'
    echo

    echo "exec /usr/bin/mysqld --user=$MYSQL_DATA_USER --console --skip-name-resolve --skip-networking=0" "$@"
fi

# execute any pre-exec scripts
for i in /scripts/pre-exec.d/*sh
do
    if [ -e "${i}" ]; then
        echo "[i] pre-exec.d - processing $i"
        . ${i}
    fi
done

exec /usr/bin/mysqld --user=$MYSQL_DATA_USER --console --skip-name-resolve --skip-networking=0 $@