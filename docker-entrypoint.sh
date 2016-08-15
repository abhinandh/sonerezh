#!/bin/ash
set -e

if [ -z "$DB_ENV_HOST" ]; then
    echo >&2 'error: missing required DB_ENV_MYSQL_PASSWORD environment variable'
    echo >&2 '  Did you forget to --link some-mysql-container:mysql?'
    exit 1
fi

if [ -z "$DB_ENV_MYSQL_DATABASE" ]; then
    echo >&2 'error: missing required DB_ENV_MYSQL_PASSWORD environment variable'
    echo >&2 '  Did you forget to --link some-mysql-container:mysql?'
    exit 1
fi

if [ -z "$DB_ENV_MYSQL_USER" ]; then
    echo >&2 'error: missing required MYSQL_USER environment variable'
    echo >&2 '  Did you forget to --link some-mysql-container:mysql?'
    exit 1
fi

if [ -z "$DB_ENV_MYSQL_PASSWORD" ]; then
    echo >&2 'error: missing required MYSQL_PASSWORD environment variable'
    echo >&2 '  Did you forget to --link some-mysql-container:mysql?'
    exit 1
fi

sed -i "s/SONEREZH_DB_PORT_3306_TCP_ADDR/${DB_ENV_HOST}/" /var/www/sonerezh/app/Config/database.php
sed -i "s/SONEREZH_DB_ENV_MYSQL_DATABASE/${DB_ENV_MYSQL_DATABASE}/" /var/www/sonerezh/app/Config/database.php
sed -i "s/SONEREZH_DB_ENV_MYSQL_USER/${DB_ENV_MYSQL_USER}/" /var/www/sonerezh/app/Config/database.php
sed -i "s/SONEREZH_DB_ENV_MYSQL_PASSWORD/${DB_ENV_MYSQL_PASSWORD}/" /var/www/sonerezh/app/Config/database.php
sed -i "s/define('DOCKER', false)/define('DOCKER', true)/" /var/www/sonerezh/app/Config/bootstrap.php

sed -i "s/memory_limit = 128M/memory_limit = 512M/" /etc/php5/php.ini
sed -i "s/max_execution_time = 30/max_execution_time = 300/" /etc/php5/php.ini

exec "$@"
