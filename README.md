# Inception

The goal of theis project is to learn the ins and outs of Docker. We do this by creating 3 Docker containers, NGINX, MariaDB and Wordpress which are controlled by a docker-compose file and started with a Makefile.

## Docker

Docker is a software platform that allows you to build, test, and deploy applications quickly. Docker packages software into standardized units called containers that have everything the software needs to run including libraries, system tools, code, and runtime.

## NGINX

NGINX is open-source web server software used for reverse proxy, load balancing, and caching. It provides HTTPS server capabilities and is mainly designed for maximum performance and stability. It also functions as a proxy server for email communications protocols, such as IMAP, POP3, and SMTP. 

We will be using it as a webserver to host the WordPress server.

## MariaDB

MariaDB is an open source database to help store and organize data. It's similar to other popular database software like MySQL, but has some unique features and improvements. Wordpress requires a database and MariaDB is easier to use than just MySQL.

## WordPress

WordPress is a tool for building websites without coding. Its ease of use and flexibility have made it the leading website creation tool worldwide. In fact, it powers nearly half of the web content.

### Building a test NGINX

docker build -t <new_image_name> .

### Check images

docker images

### Build and deploy container

docker run -d --name <name-container> -p 8080:80 <new_image_name>

### Check if build was successful

docker ps -a

### View webpage

localhost:8080