# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: schmitzi <schmitzi@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/11/22 14:29:42 by mgeiger-          #+#    #+#              #
#    Updated: 2024/11/05 10:58:22 by mgeiger-         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# Create necessary directories
setup:
	@sudo mkdir -p /home/inception/data/wordpress
	@sudo mkdir -p /home/inception/data/mariadb
	@sudo chown -R inception:inception /home/inception/data

all: setup up

up: 
	@docker compose -f ./srcs/docker-compose.yml up -d

down: 
	@docker compose -f ./srcs/docker-compose.yml down

stop: 
	@docker compose -f ./srcs/docker-compose.yml stop

start: 
	@docker compose -f ./srcs/docker-compose.yml start

restart: down up

clean: down
	@docker compose -f ./srcs/docker-compose.yml down -v
	@docker system prune -f

rebuild: clean setup
	@docker compose -f ./srcs/docker-compose.yml build --no-cache
	@docker compose -f ./srcs/docker-compose.yml up -d

status: 
	@docker ps

logs:
	@docker compose -f ./srcs/docker-compose.yml logs

logs-f:
	@docker compose -f ./srcs/docker-compose.yml logs -f

volumes:
	@docker volume ls
	@echo "Volume inspection:"
	@docker volume inspect $$(docker volume ls -q | grep -E "(wordpress|mariadb)")

.PHONY: all setup up down stop start restart clean rebuild status logs logs-f volumes