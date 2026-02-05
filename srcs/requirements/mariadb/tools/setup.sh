#!/bin/bash
set -e

if [ ! -d "/var/lib/mysql/mysql" ]; then

    cat << EOF > /tmp/init.sql
CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${SQL_USER}'@'%' IDENTIFIED BY '${SQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO '${SQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF
    mkdir -p /docker-entrypoint-initdb.d
    mv /tmp/init.sql /docker-entrypoint-initdb.d/init.sql

fi

chown -R mysql:mysql /var/lib/mysql /var/run/mysqld

echo "MariaDB starting..."
exec mysqld
