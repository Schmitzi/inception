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

all : up

up : 
	@docker compose -f ./srcs/docker-compose.yml up -d

down : 
	@docker compose -f ./srcs/docker-compose.yml down

stop : 
	@docker compose -f ./srcs/docker-compose.yml stop

start : 
	@docker compose -f ./srcs/docker-compose.yml start

restart : down up

clean : down
	@docker compose -f ./srcs/docker-compose.yml down -v
	@docker system prune -f

rebuild : clean
	@docker compose -f ./srcs/docker-compose.yml build --no-cache
	@docker compose -f ./srcs/docker-compose.yml up -d

status : 
	@docker ps

logs :
	@docker compose -f ./srcs/docker-compose.yml logs

logs-f :
	@docker compose -f ./srcs/docker-compose.yml logs -f

.PHONY: all up down stop start restart clean rebuild status logs
