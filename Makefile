NAME		= inception

SRCS_DIR	= srcs
COMPOSE		= $(SRCS_DIR)/docker-compose.yml

DATA_DIR	= /home/$(USER)/data
WP_DATA		= $(DATA_DIR)/wordpress
DB_DATA		= $(DATA_DIR)/mariadb

all: setup up

setup:
	@mkdir -p $(WP_DATA)
	@mkdir -p $(DB_DATA)
	@echo "Data directories ready."

up:
	@docker compose -f $(COMPOSE) up --build -d

down:
	@docker compose -f $(COMPOSE) down

stop:
	@docker compose -f $(COMPOSE) stop

start:
	@docker compose -f $(COMPOSE) start

logs:
	@docker compose -f $(COMPOSE) logs -f

ps:
	@docker compose -f $(COMPOSE) ps

clean: down
	@docker system prune -af

fclean: clean
	@sudo rm -rf $(WP_DATA)
	@sudo rm -rf $(DB_DATA)
	@docker volume prune -f
	@docker network prune -f
	@echo "Full clean done."

re: fclean all

.PHONY: all setup up down stop start logs ps clean fclean re