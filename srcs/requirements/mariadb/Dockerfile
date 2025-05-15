FROM debian:bullseye

# Set non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive

# Install MariaDB
RUN apt-get update && \
    apt-get install -y mariadb-server && \
    rm -rf /var/lib/apt/lists/*

# Configure MariaDB to allow remote connections
RUN sed -i 's/bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

# Create initialization script
RUN echo "CREATE DATABASE IF NOT EXISTS wordpress;" > /docker-entrypoint-initdb.d.sql && \
    echo "CREATE USER IF NOT EXISTS 'admin'@'%' IDENTIFIED BY 'password';" >> /docker-entrypoint-initdb.d.sql && \
    echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'admin'@'%';" >> /docker-entrypoint-initdb.d.sql && \
    echo "FLUSH PRIVILEGES;" >> /docker-entrypoint-initdb.d.sql

# Create startup script with proper permissions handling
RUN echo '#!/bin/bash\n\
# Create needed directories with proper permissions\n\
mkdir -p /var/lib/mysql /var/run/mysqld\n\
chown -R mysql:mysql /var/lib/mysql /var/run/mysqld\n\
chmod 777 /var/run/mysqld\n\
\n\
# Initialize database if needed\n\
if [ ! -d "/var/lib/mysql/mysql" ]; then\n\
  mysql_install_db --user=mysql --datadir=/var/lib/mysql\n\
fi\n\
\n\
# Start MySQL in background\n\
mysqld_safe --user=mysql &\n\
\n\
# Wait for MySQL to become available\n\
until mysqladmin ping -h"localhost" --silent; do\n\
  sleep 1\n\
done\n\
\n\
# Initialize database\n\
mysql < /docker-entrypoint-initdb.d.sql\n\
\n\
# Stop the background MariaDB\n\
mysqladmin -u root shutdown\n\
\n\
# Start MariaDB in foreground\n\
exec mysqld_safe --user=mysql\n' > /start.sh && \
chmod +x /start.sh

# Expose port
EXPOSE 3306

# Use the startup script
CMD ["/start.sh"]