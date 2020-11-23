#!/bin/sh

set -e

for DB in $(mysql -h "${MYSQL_HOST}" -u${MYSQL_USER} -p${MYSQL_PASS} -e "SHOW DATABASES;" --silent); do
    if [ "${DB}" = "information_schema" ] || [ "${DB}" = "test" ] || [ "${DB}" = "my_database" ] || [ "${DB}" = "performance_schema" ] || [ "${DB}" = "mysql" ] || [ "${DB}" = "Database" ]
    then
        continue
    fi

    echo "transfer ${DB}"
    mysql -h "${MYSQL_TO_HOST}" -u${MYSQL_TO_USER} -p${MYSQL_TO_PASS} -e "create database if not exists ${DB};"
    echo "dump ${DB}"
    mysqldump --opt -h "${MYSQL_HOST}" -u${MYSQL_USER} -p${MYSQL_PASS} ${DB} >db.sql
    echo "import ${DB}"
    mysql -h "${MYSQL_TO_HOST}" -u${MYSQL_TO_USER} -p${MYSQL_TO_PASS} ${DB} <db.sql
done

