
PROD_COMPOSE_FILE=docker-compose.yaml
DEV_COMPOSE_FILE=docker-compose-dev.yaml
DEBUG_COMPOSE_FILE=docker-compose-debug.yaml
TEST_COMPOSE_FILE=docker-compose-test.yaml

.PHONY: help
help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Available targets:'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

.PHONY: dev
dev: ## Start development environment with hot reloading
	docker compose -f $(DEV_COMPOSE_FILE) up

.PHONY: dev-build
dev-build: ## Build and start development environment
	docker compose -f $(DEV_COMPOSE_FILE) up --build

.PHONY: dev-down
dev-down: ## Stop development environment
	docker compose -f $(DEV_COMPOSE_FILE) down

.PHONY: debug
debug: ## Start debug environment with profiling tools
	docker compose -f $(DEBUG_COMPOSE_FILE) up

.PHONY: debug-build
debug-build: ## Build and start debug environment
	docker compose -f $(DEBUG_COMPOSE_FILE) up --build

.PHONY: debug-down
debug-build: ## Build and start debug environment
	docker compose -f $(DEBUG_COMPOSE_FILE) down

.PHONY: test
test: ## Run tests in containers
	docker compose -f $(TEST_COMPOSE_FILE) up --abort-on-container-exit

.PHONY: test-build
test-build: ## Build and run tests
	docker compose -f $(TEST_COMPOSE_FILE) up --build --abort-on-container-exit

.PHONY: prod
prod: ## Start production environment
	docker compose -f $(PROD_COMPOSE_FILE) up

.PHONY: prod-build
prod-build: ## Build and start production environment
	docker compose -f $(PROD_COMPOSE_FILE) up --build

.PHONY: compose-down
compose-down: # Down all containers
	docker compose -f $(PROD_COMPOSE_FILE) down
	docker compose -f $(DEV_COMPOSE_FILE) down
	docker compose -f $(DEBUG_COMPOSE_FILE) down
	docker compose -f $(TEST_COMPOSE_FILE) down

.PHONY: remove-all
remove-all: ## Remove all containers, volumes, and images
	docker compose -f $(PROD_COMPOSE_FILE) down -v --rmi all
	docker compose -f $(DEV_COMPOSE_FILE) down -v --rmi all
	docker compose -f $(DEBUG_COMPOSE_FILE) down -v --rmi all
	docker compose -f $(TEST_COMPOSE_FILE) down -v --rmi all

.PHONY: logs
logs: ## Follow logs from all containers
	docker compose -f $(DEV_COMPOSE_FILE) logs -f
