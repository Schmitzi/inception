# Base image with PHP-FPM
FROM debian:bullseye

RUN apt update && apt upgrade && apt install php-fpm php-mysql -y

# Start PHP-FPM
CMD ["php-fpm", "-F"]
