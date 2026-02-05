#!/bin/bash
set -e

cd /var/www/wordpress

echo "Waiting for MariaDB..."
while ! mariadb-admin ping -h"mariadb" --silent; do
    sleep 1
done
echo "MariaDB is up!"

if [ ! -f wp-config.php ]; then
    wp config create --allow-root \
        --dbname=$SQL_DATABASE \
        --dbuser=$SQL_USER \
        --dbpass=$SQL_PASSWORD \
        --dbhost=mariadb \
        --path='/var/www/wordpress'
fi

if ! wp core is-installed --allow-root; then
    wp core install --allow-root \
        --url=$DOMAIN_NAME \
        --title=$SITE_TITLE \
        --admin_user=$ADMIN_USER \
        --admin_password=$ADMIN_PASSWORD \
        --admin_email=$ADMIN_EMAIL \
        --path='/var/www/wordpress'
fi

if ! wp user get $USER_NAME --allow-root > /dev/null 2>&1; then
    wp user create --allow-root \
        $USER_NAME $USER_EMAIL \
        --user_pass=$USER_PASSWORD \
        --role=author \
        --path='/var/www/wordpress'
fi

echo "WordPress started on port 9000"
exec php-fpm7.4 -F
