NAME        = inception
SRCS        = ./srcs/docker-compose.yml
DATA_PATH   = $(HOME)/data

GREEN       = \033[0;32m
YELLOW      = \033[0;33m
RESET       = \033[0m

.PHONY: all up down build clean fclean re prep

all: prep up

prep:
	@echo "$(YELLOW)Preparing data directories...$(RESET)"
	@mkdir -p $(DATA_PATH)/mariadb
	@mkdir -p $(DATA_PATH)/wordpress

up:
	@echo "$(GREEN)Starting containers...$(RESET)"
	@docker compose -f $(SRCS) up -d

build: prep
	@echo "$(GREEN)Building and starting containers...$(RESET)"
	@docker compose -f $(SRCS) up -d --build

down:
	@echo "$(YELLOW)Stopping containers...$(RESET)"
	@docker compose -f $(SRCS) down

clean: down
	@echo "$(YELLOW)Cleaning containers and networks...$(RESET)"
	@docker system prune -a

fclean: clean
	@echo "$(YELLOW)Removing volumes and data...$(RESET)"
	@docker volume rm $$(docker volume ls -q) || true
	@sudo rm -rf $(DATA_PATH)

re: fclean all
