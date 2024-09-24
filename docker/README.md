# Local Docker Setup for Project Documentation

This folder contains the necessary files to build and run a `Docker` container for serving the documentation locally using **MkDocs** and **Material for MkDocs**.

## Prerequisites
Before using the `Makefile`, ensure the following are installed:

- Docker
- Make

---

## Usage
This project comes with a Makefile to automate Docker-related tasks, such as building images, running containers, and cleaning up resources.

## Makefile Commands

Below are the available commands in the Makefile:

### 1. Build the Docker image
To build the Docker image defined in the `docker/Dockerfile`, run:

```bash
make build
```
This command will:

Build a Docker image with the name specified in the DOCKER_IMAGE variable (project-2a-docs).

Tag the image with the version specified in DOCKER_TAG (default is latest).

Use the Dockerfile located at the DOCKERFILE_PATH (docker/Dockerfile).

### 2. Run the Docker container
To run the Docker container after building the image, run:

```bash
make run
```
This command will:

Run the container with the name project-2a-docs-container.

Map port 8000 from the container to the host (or any other port you define in the PORT variable).

Automatically remove the container when it stops (--rm).
Once running, the application will be accessible at http://localhost:8000.

### 3. Stop the Docker container
If the container is running, you can stop it with:

```bash
make stop
```
This will stop the container named project-2a-docs-container. If the container is not running, this command will not cause any errors.

### 3. Clean up Docker images
To remove the Docker image created by the build command, run:

```bash
make clean
```
This will:

Remove the Docker image specified by DOCKER_IMAGE and DOCKER_TAG.

If the image is not found, the command will fail silently due to || true in the command.

### 4. Full Workflow Example
Build the Docker image:

```bash
make build
```

Run the Docker container:

```bash
make run
```

Stop the Docker container:

```bash
make stop
```

Clean up the Docker image:

```bash
make clean
```

### 5. Customizing the Makefile
The following variables are defined in the Makefile, and you can customize them as needed:

1. `DOCKER_IMAGE`: The name of the Docker image (default is project-2a-docs).
1. `DOCKERFILE_PATH`: The path to the Dockerfile (default is docker/Dockerfile).
1. `DOCKER_TAG`: The tag for the Docker image (default is latest).
1. `CONTAINER_NAME`: The name of the container (default is project-2a-docs-container).
1. `PORT`: The port the container will expose to the host (default is 8000).

---

This `README.md` now provides clear instructions on how to use the `Makefile` for building, running, stopping, and cleaning up Docker images and containers.