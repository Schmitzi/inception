FROM debian:bullseye

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y nginx openssl && \
    rm -rf /var/lib/apt/lists/*

# Generate self-signed certificate
RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=FR/ST=Paris/L=Paris/O=42/OU=42/CN=mgeiger-.42.fr"

# Copy configuration from directory to Nginx
COPY conf /etc/nginx/sites-available/default

# Expose port for HTTPS
EXPOSE 443

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]