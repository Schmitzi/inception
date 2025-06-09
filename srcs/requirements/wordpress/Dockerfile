FROM debian:bullseye

# Install required packages, NO NGINX ALLOWED HERE!
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y \
    php7.4 \
    php7.4-fpm \
    php7.4-mysql \
    php7.4-gd \
    php7.4-curl \
    php7.4-mbstring \
    php7.4-xml \
    php7.4-zip \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Create all necessary directories
RUN mkdir -p /run/php /var/run/php

# Copy startup script and give proper permissions
COPY start.sh /start.sh
RUN chmod +x start.sh

# Configure PHP-FPM to listen on network
RUN sed -i 's/listen = \/run\/php\/php7.4-fpm.sock/listen = 9000/' /etc/php/7.4/fpm/pool.d/www.conf

# Expose port for PHP-FPM
EXPOSE 9000

# Set working directory
WORKDIR /var/www/html

# Use the startup script
CMD ["/start.sh"]