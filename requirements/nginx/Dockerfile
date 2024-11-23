FROM debian:bullseye

RUN apt-get update && apt-get upgrade && apt-get install -y nginx

CMD ["nginx", "-g", "daemon off;"]