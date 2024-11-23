FROM debian:bullseye

# Install necessary packages
RUN apt-get update && apt-get install -y \
    php-fpm \
    php-mysqli \
    php-curl \
    php-gd \
    php-xml \
    php-mbstring \
    wget \
    unzip

# Install WordPress CLI (optional but helpful)
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Set the command to start PHP-FPM in the foreground
CMD ["php-fpm", "-F"]
