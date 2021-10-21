
.PHONY: build run

build: ## Docker build
	docker build -t ask-front --build-arg REACT_APP_BACKEND_SECRET_KEY --build-arg REACT_APP_API_URL .

run: ## Docker run
	docker run --rm -p 8080:80 ask-front

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\t\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help
