#!/bin/bash
set -e

DB_USER=$(cat /run/secrets/db_user)
DB_PASSWORD=$(cat /run/secrets/db_password)
DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)

# Create initialization script dynamically
cat > /docker-entrypoint-initdb.d.sql << EOF
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${DB_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

# Create needed directories with proper permissions
mkdir -p /var/lib/mysql /var/run/mysqld
chown -R mysql:mysql /var/lib/mysql /var/run/mysqld
chmod 777 /var/run/mysqld

# Initialize database if needed
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB database..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# Start MySQL in background
echo "Starting MariaDB temporarily..."
mysqld_safe --user=mysql &
MYSQL_PID=$!

# Wait for MySQL to become available
echo "Waiting for MariaDB to be ready..."
until mysqladmin ping -h"localhost" --silent; do
    sleep 1
done

echo "MariaDB is ready, initializing database..."

# Initialize database
mysql < /docker-entrypoint-initdb.d.sql

# Stop the background MariaDB
echo "Stopping temporary MariaDB instance..."
mysqladmin -u root shutdown
wait $MYSQL_PID

# Start MariaDB in foreground
echo "Starting MariaDB in foreground..."
exec mysqld_safe --user=mysql