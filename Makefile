# Variables
DOCKER_IMAGE = project-2a-docs
DOCKERFILE_PATH = Dockerfile
DOCKER_TAG = latest
CONTAINER_NAME = project-2a-docs
PORT = 8000

# Default target
.PHONY: all
all: build run

# Build the Docker image
.PHONY: build
build:
	docker build -t $(DOCKER_IMAGE):$(DOCKER_TAG) -f $(DOCKERFILE_PATH) .

# Run the Docker container (checks if the image exists before running)
.PHONY: run
run: check-image
	docker run --rm -p $(PORT):8000 -v ${PWD}:/docs --name $(CONTAINER_NAME) $(DOCKER_IMAGE):$(DOCKER_TAG)

# Stop the container if it's running
.PHONY: stop
stop:
	@docker ps -q --filter "name=$(CONTAINER_NAME)" | grep -q . && docker stop $(CONTAINER_NAME)

# Clean up Docker images and containers (calls stop first)
.PHONY: clean
clean: stop
	docker rmi $(DOCKER_IMAGE):$(DOCKER_TAG)

# Check if the image exists; if not, build it
.PHONY: check-image
check-image:
	@if ! docker image inspect $(DOCKER_IMAGE):$(DOCKER_TAG) > /dev/null 2>&1; then \
		echo "Image $(DOCKER_IMAGE):$(DOCKER_TAG) not found. Building..."; \
		$(MAKE) build; \
	fi
