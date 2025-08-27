#!/bin/bash
set -e

# Create directories
echo "Creating PHP directories..."
mkdir -p /run/php
mkdir -p /var/run/php

echo "WordPress DB Config:"
echo "Host: $WORDPRESS_DB_HOST"
echo "Database: $WORDPRESS_DB_NAME" 
echo "User: $WORDPRESS_DB_USER"

# Download WordPress if not already present
if [ ! -f /var/www/html/wp-config.php ] && [ ! -f /var/www/html/index.php ]; then
    echo "WordPress not found, downloading..."
    wget https://wordpress.org/latest.tar.gz -O /tmp/wordpress.tar.gz
    tar -xzf /tmp/wordpress.tar.gz -C /tmp/
    cp -r /tmp/wordpress/* /var/www/html/
    rm -rf /tmp/wordpress.tar.gz /tmp/wordpress
    echo "WordPress downloaded and extracted."
fi

# Wait for database to be ready
echo "Waiting for database connection..."
for i in {1..30}; do
    if mysql -h ${WORDPRESS_DB_HOST%:*} -P ${WORDPRESS_DB_HOST#*:} -u ${WORDPRESS_DB_USER} -p${WORDPRESS_DB_PASSWORD} -e "SELECT 1" >/dev/null 2>&1; then
        echo "Database connection successful!"
        break
    fi
    if [ $i -eq 30 ]; then
        echo "ERROR: Could not connect to database after 30 attempts"
        echo "Host: ${WORDPRESS_DB_HOST}"
        echo "User: ${WORDPRESS_DB_USER}"
        exit 1
    fi
    echo "Waiting for database... ($i/30)"
    sleep 2
done

# Set correct permissions
echo "Setting file permissions..."
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

# Start PHP-FPM
echo "Starting PHP-FPM..."
exec php-fpm7.4 -F