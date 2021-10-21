
.PHONY: build run

build: ## Docker build
	docker build -t ask-back .

run: ## Docker run
	docker run --rm -p 8080:3000 --env-file .env ask-back

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\t\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help
