#!/bin/bash
set -e

echo "Starting MariaDB setup..."

# Read secrets
DB_USER=$(cat /run/secrets/db_user)
DB_PASSWORD=$(cat /run/secrets/db_password)
DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)

echo "Database user: $DB_USER"

# Create needed directories with proper permissions
mkdir -p /var/lib/mysql /var/run/mysqld
chown -R mysql:mysql /var/lib/mysql /var/run/mysqld
chmod 755 /var/run/mysqld

# Check if database is already initialized
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Database not initialized. Initializing..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql --rpm
    
    # Start MariaDB temporarily to set it up
    echo "Starting MariaDB for initial setup..."
    mysqld_safe --user=mysql --skip-networking &
    MYSQL_PID=$!
    
    # Wait for MySQL to start
    echo "Waiting for MariaDB to be ready..."
    for i in {1..30}; do
        if mysqladmin ping --silent; then
            echo "MariaDB is ready!"
            break
        fi
        echo "Waiting... ($i/30)"
        sleep 2
    done
    
    # Setup database and users
    echo "Setting up database and users..."
    mysql -e "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('${DB_ROOT_PASSWORD}');"
    mysql -u root -p${DB_ROOT_PASSWORD} -e "CREATE DATABASE IF NOT EXISTS wordpress;"
    mysql -u root -p${DB_ROOT_PASSWORD} -e "CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';"
    mysql -u root -p${DB_ROOT_PASSWORD} -e "GRANT ALL PRIVILEGES ON wordpress.* TO '${DB_USER}'@'%';"
    mysql -u root -p${DB_ROOT_PASSWORD} -e "FLUSH PRIVILEGES;"
    
    # Stop the temporary instance
    echo "Stopping temporary MariaDB..."
    mysqladmin -u root -p${DB_ROOT_PASSWORD} shutdown
    wait $MYSQL_PID
    
    echo "Database initialization complete!"
else
    echo "Database already initialized."
fi

# Start MariaDB in foreground
echo "Starting MariaDB in foreground mode..."
exec mysqld_safe --user=mysql