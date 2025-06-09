# RK Debugger Docker Container

This folder provides a Docker container and supporting scripts for a feature-rich debugging and development environment.

## Available Makefile Actions

Below are the available actions (targets) in the `makefile`:

### 1. `build`

Builds the Docker image, tags it for both personal and Netskope Artifactory registries.

```sh
make build
```

### 2. `ns-push`

Pushes the Docker image to the Netskope Artifactory Docker registry using JFrog CLI.

```sh
make ns-push
```

### 3. `personal-push`

Pushes the Docker image to your personal DockerHub account. Requires `DOCKER_PASSWORD` to be set in the environment.

```sh
export DOCKER_PASSWORD="<your_password>"
make personal-push
```

### 4. `run`

Runs the Docker container interactively with the default image and version.

```sh
make run
```

### 5. `run-with-mount`

Runs the Docker container with host directories mounted into the container, based on the host machine. Installs `nsk` inside the container after startup.

```sh
make run-with-mount
```

### 6. `run-pod-with-mount`

Creates a Kubernetes Pod with the Docker image and mounts host directories as volumes. Waits for the pod to be ready and then opens a Zsh shell.

```sh
make run-pod-with-mount
```

### 7. `remove`

Removes the running Docker container (if any) with the configured name.

```sh
make remove
```

### 8. `remove-pod`

Deletes the Kubernetes Pod (if any) with the configured name.

```sh
make remove-pod
```

### 9. `install-nsk`

Installs the `nsk` CLI tool inside the running Docker container.

```sh
make install-nsk
```

---