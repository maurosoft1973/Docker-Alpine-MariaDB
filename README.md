# MariaDB Docker Image with Multilanguage e Timezone support running on Alpine Linux

[![Docker Automated build](https://img.shields.io/docker/automated/maurosoft1973/alpine-mariadb.svg?style=for-the-badge&logo=docker)](https://hub.docker.com/r/maurosoft1973/alpine-mariadb/)
[![Docker Pulls](https://img.shields.io/docker/pulls/maurosoft1973/alpine-mariadb.svg?style=for-the-badge&logo=docker)](https://hub.docker.com/r/maurosoft1973/alpine-mariadb/)
[![Docker Stars](https://img.shields.io/docker/stars/maurosoft1973/alpine-mariadb.svg?style=for-the-badge&logo=docker)](https://hub.docker.com/r/maurosoft1973/alpine-mariadb/)

[![Alpine Version](https://img.shields.io/badge/Alpine%20version-v3.21.0-green.svg?style=for-the-badge)](https://alpinelinux.org/)
[![MariaDB Version](https://img.shields.io/docker/v/maurosoft1973/alpine-mariadb?sort=semver&style=for-the-badge)](https://mariadb.org/)

This Docker image [(maurosoft1973/alpine-mariadb)](https://hub.docker.com/r/maurosoft1973/alpine-mariadb/) is based on the minimal [Alpine Linux](https://alpinelinux.org/) with [MariaDB v11.4.4-r1](https://mariadb.org/) (MySQL Compatible) database server.

##### Alpine Version 3.21.0 (Released 2024-12-05)
##### MariaDB Version 11.4.4-r1 (Released 2024-11-22)

----

## What is Alpine Linux?
Alpine Linux is a Linux distribution built around musl libc and BusyBox. The image is only 5 MB in size and has access to a package repository that is much more complete than other BusyBox based images. This makes Alpine Linux a great image base for utilities and even production applications. Read more about Alpine Linux here and you can see how their mantra fits in right at home with Docker images.

## What is MariaDB?
MariaDB Server is one of the most popular database servers in the world. It's made by the original developers of MySQL and guaranteed to stay open source. Notable users include Wikipedia, WordPress.com and Google.

MariaDB turns data into structured information in a wide array of applications, ranging from banking to websites. It is an enhanced, drop-in replacement for MySQL. MariaDB is used because it is fast, scalable and robust, with a rich ecosystem of storage engines, plugins and many other tools make it very versatile for a wide variety of use cases.

MariaDB is developed as open source software and as a relational database it provides an SQL interface for accessing data. The latest versions of MariaDB also include GIS and JSON features.

## Features

* Minimal size only, minimal layers
* Memory usage is minimal on a simple install
* Multilanguage support
* Timezone support
* MariaDB the MySQL replacement.

## Architectures

* ```:aarch64``` - 64 bit ARM
* ```:armhf```   - 32 bit ARM v6
* ```:armv7```   - 32 bit ARM v7
* ```:ppc64le``` - 64 bit PowerPC
* ```:x86```     - 32 bit Intel/AMD
* ```:x86_64```  - 64 bit Intel/AMD (x86_64/amd64)

## Tags

* ```:latest```         latest branch based (Automatic Architecture Selection)
* ```:aarch64```        latest 64 bit ARM
* ```:armhf```          latest 32 bit ARM v6
* ```:armv7```          latest 32 bit ARM v7
* ```:ppc64le```        latest 64 bit PowerPC
* ```:x86```            latest 32 bit Intel/AMD
* ```:x86_64```         latest 64 bit Intel/AMD
* ```:test```           test branch based (Automatic Architecture Selection)
* ```:test-aarch64```   test 64 bit ARM
* ```:test-armhf```     test 32 bit ARM v6
* ```:test-armv7```     test 32 bit ARM v7
* ```:test-ppc64le```   test 64 bit PowerPC
* ```:test-x86```       test 32 bit Intel/AMD
* ```:test-x86_64```    test 64 bit Intel/AMD
* ```:3.21.0-11.4.4-r1``` 3.21.0-11.4.4-r1 branch based (Automatic Architecture Selection)
* ```:3.21.0-11.4.4-r1-aarch64```   3.21.0 64 bit ARM
* ```:3.21.0-11.4.4-r1-armhf```     3.21.0 32 bit ARM v6
* ```:3.21.0-11.4.4-r1-armv7```     3.21.0 32 bit ARM v7
* ```:3.21.0-11.4.4-r1-ppc64le```   3.21.0 64 bit PowerPC
* ```:3.21.0-11.4.4-r1-x86```       3.21.0 32 bit Intel/AMD
* ```:3.21.0-11.4.4-r1-x86_64```    3.21.0 64 bit Intel/AMD

## Layers & Sizes

| Version                                                                               | Size                                                                                                                 |
|---------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------|
| ![Version](https://img.shields.io/badge/version-amd64-blue.svg?style=for-the-badge)   | ![MicroBadger Size (tag)](https://img.shields.io/docker/image-size/maurosoft1973/alpine-mariadb/latest?style=for-the-badge)  |
| ![Version](https://img.shields.io/badge/version-aarch64-blue.svg?style=for-the-badge) | ![MicroBadger Size (tag)](https://img.shields.io/docker/image-size/maurosoft1973/alpine-mariadb/aarch64?style=for-the-badge)   |
| ![Version](https://img.shields.io/badge/version-armv6-blue.svg?style=for-the-badge)   | ![MicroBadger Size (tag)](https://img.shields.io/docker/image-size/maurosoft1973/alpine-mariadb/armhf?style=for-the-badge)   |
| ![Version](https://img.shields.io/badge/version-armv7-blue.svg?style=for-the-badge)   | ![MicroBadger Size (tag)](https://img.shields.io/docker/image-size/maurosoft1973/alpine-mariadb/armv7?style=for-the-badge)   |
| ![Version](https://img.shields.io/badge/version-ppc64le-blue.svg?style=for-the-badge) | ![MicroBadger Size (tag)](https://img.shields.io/docker/image-size/maurosoft1973/alpine-mariadb/ppc64le?style=for-the-badge) |
| ![Version](https://img.shields.io/badge/version-x86-blue.svg?style=for-the-badge)     | ![MicroBadger Size (tag)](https://img.shields.io/docker/image-size/maurosoft1973/alpine-mariadb/x86?style=for-the-badge)     |

## Volume structure

* `/etc/my.cnf.d`: MariaDB Configuration file
* `/var/lib/mysql`: Database files
* `/var/lib/mysql/mysql-bin`: MariaDB logs

## Environment Variables:

### Main MariaDB parameters:
* `LC_ALL`: default locale (en_GB.UTF-8)
* `TIMEZONE`: default timezone (Europe/Brussels)
* `MYSQL_DATA_USER`: specify the mysql owner data directory (default = mysql)
* `MYSQL_DATA_USER_UID`: specify the uid for mysql owner data directory (default = 100)
* `MYSQL_DATA_GROUP`: specify the mysql group data directory (default = mysql)
* `MYSQL_DATA_GROUP_UID`: specify the gid for mysql group data directory (default = 101)
* `MYSQL_DATABASE`: specify the name of the database (default = demo)
* `MYSQL_CHARSET`: specify charset of MYSQL_DATABASE (default = utf8)
* `MYSQL_COLLATION`: specify collation of MYSQL_DATABASE (default = utf8_general_ci) for Mariadb
* `MYSQL_USER`: specify the user for the MYSQL_DATABASE (default = demo)
* `MYSQL_PASSWORD`: specify the user password for access MYSQL_DATABASE (if empty, is autogenerate)
* `MYSQL_PASSWORD_LENGTH`: specify the length user password for MYSQL_DATABASE (use if MYSQL_PASSWORD password is empty)
* `MYSQL_ROOT_PASSWORD`: specify the root password for Mariadb (if empty, is autogenerate)
* `MYSQL_ROOT_PASSWORD_LENGTH`: specify the length root password for Mariadb (use if MYSQL_ROOT_PASSWORD password is empty)
* `MYSQL_REPLICATION`: if 1, replication is enabled (default 0)
* `MYSQL_REPLICATION_USER`: specify the user used for replication (default = replic)
* `MYSQL_REPLICATION_PASSWORD`: specify the user password  (default = replic)
* `MYSQL_REPLICATION_SERVER_ID`: The server id is a unique number for each MariaDB/MySQL server in your network (default = 1). It must be a unique value for each server in the replication
* `MYSQL_REPLICATION_LOG_BIN`: enables the binlog required for replication. (default /var/log/mysql/mysql-bin.log)
* `MYSQL_REPLICATION_BINLOG_FORMAT`: This system variable sets the binary logging format, and can be any one of STATEMENT, ROW, or MIXED (default ROW)
* `MYSQL_REPLICATION_BINLOG_EXPIRE_LOG_SECONDS`: Sets the binary log expiration period in seconds. After their expiration period ends, binary log files can be automatically removed (default 864000)
* `MYSQL_REPLICATION_MAX_BINLOG_SIZE`: If a write to the binary log causes the current log file size to exceed the value of this variable, the server rotates the binary logs (closes the current file and opens the next one). (default 500M)

#### List of locale Sets

When setting locale, also make sure to choose a locale otherwise it will be the default (en_GB.UTF-8).

```
+-----------------+
| Locale          |
+-----------------+
| fr_CH.UTF-8     |
| fr_FR.UTF-8     |
| de_CH.UTF-8     |
| de_DE.UTF-8     |
| en_GB.UTF-8     |
| en_US.UTF-8     |
| es_ES.UTF-8     |
| it_CH.UTF-8     |
| it_IT.UTF-8     |
| nb_NO.UTF-8     |
| nl_NL.UTF-8     |
| pt_PT.UTF-8     |
| pt_BR.UTF-8     |
| ru_RU.UTF-8     |
| sv_SE.UTF-8     |
+-----------------+
```

#### List of Character Sets & information

When setting charset, also make sure to choose a collation otherwise it will be the default.

```
+----------+-----------------------------+---------------------+--------+
| Charset  | Description                 | Default collation   | Maxlen |
+----------+-----------------------------+---------------------+--------+
| big5     | Big5 Traditional Chinese    | big5_chinese_ci     |      2 |
| dec8     | DEC West European           | dec8_swedish_ci     |      1 |
| cp850    | DOS West European           | cp850_general_ci    |      1 |
| hp8      | HP West European            | hp8_english_ci      |      1 |
| koi8r    | KOI8-R Relcom Russian       | koi8r_general_ci    |      1 |
| latin1   | cp1252 West European        | latin1_swedish_ci   |      1 |
| latin2   | ISO 8859-2 Central European | latin2_general_ci   |      1 |
| swe7     | 7bit Swedish                | swe7_swedish_ci     |      1 |
| ascii    | US ASCII                    | ascii_general_ci    |      1 |
| ujis     | EUC-JP Japanese             | ujis_japanese_ci    |      3 |
| sjis     | Shift-JIS Japanese          | sjis_japanese_ci    |      2 |
| hebrew   | ISO 8859-8 Hebrew           | hebrew_general_ci   |      1 |
| tis620   | TIS620 Thai                 | tis620_thai_ci      |      1 |
| euckr    | EUC-KR Korean               | euckr_korean_ci     |      2 |
| koi8u    | KOI8-U Ukrainian            | koi8u_general_ci    |      1 |
| gb2312   | GB2312 Simplified Chinese   | gb2312_chinese_ci   |      2 |
| greek    | ISO 8859-7 Greek            | greek_general_ci    |      1 |
| cp1250   | Windows Central European    | cp1250_general_ci   |      1 |
| gbk      | GBK Simplified Chinese      | gbk_chinese_ci      |      2 |
| latin5   | ISO 8859-9 Turkish          | latin5_turkish_ci   |      1 |
| armscii8 | ARMSCII-8 Armenian          | armscii8_general_ci |      1 |
| utf8     | UTF-8 Unicode               | utf8_general_ci     |      3 |
| ucs2     | UCS-2 Unicode               | ucs2_general_ci     |      2 |
| cp866    | DOS Russian                 | cp866_general_ci    |      1 |
| keybcs2  | DOS Kamenicky Czech-Slovak  | keybcs2_general_ci  |      1 |
| macce    | Mac Central European        | macce_general_ci    |      1 |
| macroman | Mac West European           | macroman_general_ci |      1 |
| cp852    | DOS Central European        | cp852_general_ci    |      1 |
| latin7   | ISO 8859-13 Baltic          | latin7_general_ci   |      1 |
| utf8mb4  | UTF-8 Unicode               | utf8mb4_general_ci  |      4 |
| cp1251   | Windows Cyrillic            | cp1251_general_ci   |      1 |
| utf16    | UTF-16 Unicode              | utf16_general_ci    |      4 |
| utf16le  | UTF-16LE Unicode            | utf16le_general_ci  |      4 |
| cp1256   | Windows Arabic              | cp1256_general_ci   |      1 |
| cp1257   | Windows Baltic              | cp1257_general_ci   |      1 |
| utf32    | UTF-32 Unicode              | utf32_general_ci    |      4 |
| binary   | Binary pseudo charset       | binary              |      1 |
| geostd8  | GEOSTD8 Georgian            | geostd8_general_ci  |      1 |
| cp932    | SJIS for Windows Japanese   | cp932_japanese_ci   |      2 |
| eucjpms  | UJIS for Windows Japanese   | eucjpms_japanese_ci |      3 |
+----------+-----------------------------+---------------------+--------+
```

> https://mariadb.org/

## Example of use

### 1. Create a container with default value

```sh
docker run --rm --name mysql -p 3306:3306 -v /var/lib/mysql:/var/lib/mysql maurosoft1973/alpine-mariadb
```

### 2. Create a container with charset utf8mb4, collation utf8mb4_unicode_ci and default value

```bash
docker run --rm --name mysql -p 3306:3306 -v /var/lib/mysql:/var/lib/mysql -e MYSQL_CHARSET=utf8mb4 -e MYSQL_COLLATION=utf8mb4_unicode_ci maurosoft1973/alpine-mariadb
```

### 3. Create a container with init script for populate database from dump

When a container is started for the first time, a new database with the specified name will be created and initialized with the provided 
configuration variables. Furthermore, it will execute files with extensions .sh, .sql and .sql.gz that are found in /docker-entrypoint-initdb.d. 
Files will be executed in alphabetical order. You can easily populate your mariadb services by mounting a SQL dump into that directory and provide 
custom images with contributed data. SQL files will be imported by default to the database specified by the MYSQL_DATABASE variable.

```sh
docker run --rm --name mysql -p 3306:3306 -v /var/lib/mysql:/var/lib/mysql -v /myscript/initdb:/docker-entrypoint-initdb.d -v /myscript/pre-init:/scripts/pre-init.d -e MYSQL_DATABASE=dbtest -e MYSQL_USER=user -e MYSQL_PASSWORD=pwd -e MYSQL_ROOT_PASSWORD=root maurosoft1973/alpine-mariadb
```

## 4. Docker compose example

##### (Please pass your own credentials or let them be generated automatically, don't use these ones for production!!)

```yalm
mysql:
  image: maurosoft1973/alpine-mariadb
  environment:
    MYSQL_ROOT_PASSWORD: test
    MYSQL_DATABASE: dbtest
    MYSQL_USER: test
    MYSQL_PASSWORD: root
  expose:
    - "3306"
  volumes:
    - /var/data/mysql:/var/lib/mysql
  restart: always
```

***
###### Last Update 06.01.2025 17:11:04
