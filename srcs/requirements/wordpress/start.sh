#!/bin/bash
set -e

# Create directories
echo "Creating PHP directories..."
mkdir -p /run/php
mkdir -p /var/run/php

# Download WordPress if not already present
if [ ! -f /var/www/html/wp-config.php ] && [ ! -f /var/www/html/index.php ]; then
    echo "WordPress not found, downloading..."
    wget https://wordpress.org/latest.tar.gz -O /tmp/wordpress.tar.gz
    tar -xzf /tmp/wordpress.tar.gz -C /tmp/
    cp -r /tmp/wordpress/* /var/www/html/
    rm -rf /tmp/wordpress.tar.gz /tmp/wordpress
    echo "WordPress downloaded and extracted."
fi

# Set correct permissions
echo "Setting file permissions..."
chown -R www-data:www-data /var/www/html

# Start PHP-FPM
echo "Starting PHP-FPM..."
exec php-fpm7.4 -F