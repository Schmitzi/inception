#!/bin/bash
set -e

echo "Starting MariaDB setup..."
echo "Database user: $MYSQL_USER"
echo "Database name: $MYSQL_DATABASE"

# Create needed directories with proper permissions
echo "Setting up directories..."
mkdir -p /var/lib/mysql /var/run/mysqld
chown -R mysql:mysql /var/lib/mysql /var/run/mysqld
chmod 755 /var/run/mysqld

# Check if database is already initialized (check for both system tables and our custom database)
if [ ! -d "/var/lib/mysql/mysql" ] || [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then
    echo "Database initialization required (mysql system tables or ${MYSQL_DATABASE} missing)"
    
    # Only run mysql_install_db if system tables don't exist
    if [ ! -d "/var/lib/mysql/mysql" ]; then
        echo "Installing MySQL system tables..."
        mysql_install_db --user=mysql --datadir=/var/lib/mysql --rpm
    fi
    
    # Start MariaDB temporarily to set it up
    echo "Starting MariaDB for initial setup..."
    mysqld_safe --user=mysql --skip-networking --skip-grant-tables &
    MYSQL_PID=$!
    
    # Wait for MySQL to start
    echo "Waiting for MariaDB to be ready..."
    for i in {1..60}; do
        if mysqladmin ping --silent 2>/dev/null; then
            echo "MariaDB is ready!"
            break
        fi
        if [ $i -eq 60 ]; then
            echo "ERROR: MariaDB failed to start within 60 seconds"
            exit 1
        fi
        echo "Waiting... ($i/60)"
        sleep 1
    done
    
    # Setup database and users
    echo "Setting up database and users..."
    echo "Creating database: ${MYSQL_DATABASE}"
    echo "Creating user: ${MYSQL_USER} with access from any host"
    
    mysql -u root << EOF
FLUSH PRIVILEGES;
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('${MYSQL_ROOT_PASSWORD}');
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF
    
    # Verify the setup
    echo "Verifying database setup..."
    mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "SHOW DATABASES;" | grep ${MYSQL_DATABASE}
    mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "SELECT User, Host FROM mysql.user WHERE User='${MYSQL_USER}';"
    
    # Stop the temporary instance
    echo "Stopping temporary MariaDB..."
    mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} shutdown 2>/dev/null || kill $MYSQL_PID
    wait $MYSQL_PID 2>/dev/null || true
    
    echo "Database initialization complete!"
else
    echo "Database already initialized."
fi

# Start MariaDB in foreground
echo "Starting MariaDB in foreground mode..."
exec mysqld_safe --user=mysql