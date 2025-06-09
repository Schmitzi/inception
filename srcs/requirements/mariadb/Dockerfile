FROM debian:bullseye

# Set non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive

# Install MariaDB, NO NGINX ALLOWED!
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

# Copy startup script and give proper permissions
COPY start.sh /start.sh
RUN chmod +x start.sh

# Expose port
EXPOSE 3306

# Use the startup script
CMD ["/start.sh"]