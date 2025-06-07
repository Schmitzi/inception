FROM debian:bullseye

# Install required packages
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

# Create startup script that sets up the environment properly
RUN echo '#!/bin/bash\n\
# Create directories\n\
mkdir -p /run/php\n\
mkdir -p /var/run/php\n\
\n\
# Download WordPress if not already present\n\
if [ ! -f /var/www/html/wp-config.php ] && [ ! -f /var/www/html/index.php ]; then\n\
  echo "WordPress not found, downloading..."\n\
  wget https://wordpress.org/latest.tar.gz -O /tmp/wordpress.tar.gz\n\
  tar -xzf /tmp/wordpress.tar.gz -C /tmp/\n\
  cp -r /tmp/wordpress/* /var/www/html/\n\
  rm -rf /tmp/wordpress.tar.gz /tmp/wordpress\n\
  echo "WordPress downloaded and extracted."\n\
fi\n\
\n\
# Set correct permissions\n\
chown -R www-data:www-data /var/www/html\n\
\n\
# Start PHP-FPM\n\
echo "Starting PHP-FPM..."\n\
exec php-fpm7.4 -F' > /start.sh && \
chmod +x /start.sh

# Configure PHP-FPM to listen on network
RUN sed -i 's/listen = \/run\/php\/php7.4-fpm.sock/listen = 9000/' /etc/php/7.4/fpm/pool.d/www.conf

# Expose port for PHP-FPM
EXPOSE 9000

# Set working directory
WORKDIR /var/www/html

# Use the startup script
CMD ["/start.sh"]