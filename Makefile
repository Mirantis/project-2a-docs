# Variables
DOCKER_IMAGE = project-2a-docs
DOCKERFILE_PATH = docker/Dockerfile
DOCKER_TAG = latest
CONTAINER_NAME = project-2a-docs-container
PORT = 8000

# Default target
.PHONY: all
all: build run

# Build the Docker image
.PHONY: build
build:
	docker build -t $(DOCKER_IMAGE):$(DOCKER_TAG) -f $(DOCKERFILE_PATH) .

# Run the Docker container
.PHONY: run
run:
	docker run --rm -p $(PORT):8000 -v $(shell pwd):/docs --name $(CONTAINER_NAME) $(DOCKER_IMAGE):$(DOCKER_TAG)

# Stop the container if it's running
.PHONY: stop
stop:
	docker stop $(CONTAINER_NAME) || true

# Clean up Docker images and containers
.PHONY: clean
clean:
	docker rmi $(DOCKER_IMAGE):$(DOCKER_TAG) || true
