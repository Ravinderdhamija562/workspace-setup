SHELL := /bin/bash
# Makefile to manage the rk-debugger-docker-container

# Variables
IMAGE_NAME := rk-debugger
IMAGE_VERSION := 2.0.0
DOCKERFILE := Dockerfile
CONTAINER_NAME := rk-debugger-container
PERSONAL_DOCKER_ACCOUNT := rinku562
NS_DOCKER_ACCOUNT := artifactory.netskope.io/ep-tools-docker
DOCKER_USERNAME ?= rinku562
DOCKER_PASSWORD ?= $(shell echo $$DOCKER_PASSWORD)

# Targets
.PHONY: build run

build:
	docker build -t $(IMAGE_NAME):$(IMAGE_VERSION) -f $(DOCKERFILE) .
	docker tag $(IMAGE_NAME):$(IMAGE_VERSION) $(PERSONAL_DOCKER_ACCOUNT)/$(IMAGE_NAME):$(IMAGE_VERSION)
	docker tag $(IMAGE_NAME):$(IMAGE_VERSION) $(NS_DOCKER_ACCOUNT)/$(IMAGE_NAME):$(IMAGE_VERSION)

ns-push:
	jf config use rtf-admin
	jf docker push $(NS_DOCKER_ACCOUNT)/$(IMAGE_NAME):$(IMAGE_VERSION)

personal-push:
	# export DOCKER_PASSWORD="fled**"; make personal-push
	echo "$(DOCKER_PASSWORD)" | docker login -u $(DOCKER_USERNAME) --password-stdin
	docker push $(PERSONAL_DOCKER_ACCOUNT)/$(IMAGE_NAME):$(IMAGE_VERSION)

run: remove
	docker run --name $(CONTAINER_NAME) -it $(IMAGE_NAME):$(IMAGE_VERSION)

run-with-mount: remove
	@echo "Determining host machine..."; \
	HOSTNAME=$$(hostname); \
	echo "Host machine: $$HOSTNAME"; \
	echo "Setting paths based on host machine..."; \
	if [ "$$HOSTNAME" = "CT4WL2KYTX" ]; then \
		MOUNT_PATHS=( \
			"/Users/ravinderk/git:/root/git" \
			"/Users/ravinderk/.kube/config:/root/.kube/config" \
			"/Users/ravinderk/.ssh:/root/.ssh" \
			"/Users/ravinderk/.nsk/configuration:/root/.nsk/configuration" \
			"/Users/ravinderk/.config/gh:/root/.config/gh" \
		); \
	elif [ "$$HOSTNAME" = "rk-bastion" ]; then \
		MOUNT_PATHS=( \
			"/home/ravinderk/git:/root/git" \
			"/home/ravinderk/.kube/config:/root/.kube/config" \
			"/home/ravinderk/.ssh:/root/.ssh" \
			"/home/ravinderk/.nsk/configuration:/root/.nsk/configuration" \
			"/home/ravinderk/.config/gh:/root/.config/gh" \
		); \
	else \
		MOUNT_PATHS=( "$$HOME/.ssh:/root/.ssh" ); \
	fi; \
	echo "Mount paths: $${MOUNT_PATHS[@]}"; \
	echo "Running Docker container with available mounts..."; \
	MOUNT_OPTS=""; \
	for MOUNT in "$${MOUNT_PATHS[@]}"; do \
		HOST_PATH=$$(echo $$MOUNT | cut -d':' -f1); \
		CONTAINER_PATH=$$(echo $$MOUNT | cut -d':' -f2); \
		if [ -e "$$HOST_PATH" ]; then \
			MOUNT_OPTS="$$MOUNT_OPTS -v $$HOST_PATH:$$CONTAINER_PATH"; \
		else \
			echo "$$HOST_PATH not found, skipping mount."; \
		fi; \
	done; \
	docker run --name $(CONTAINER_NAME) $$MOUNT_OPTS -dit $(PERSONAL_DOCKER_ACCOUNT)/$(IMAGE_NAME):$(IMAGE_VERSION); \
	docker exec -it $(CONTAINER_NAME) bash -c "gh release download v0.1.231 --repo netSkopePlatformEng/nsk --pattern '*amd64.deb' && dpkg -i nsk_0.1.231_linux_amd64.deb" && \
	docker exec -it $(CONTAINER_NAME) zsh

run-pod-with-mount: remove-pod
	@echo "Determining host machine..."; \
	HOSTNAME=$$(hostname); \
	echo "Host machine: $$HOSTNAME"; \
	echo "Setting paths based on host machine..."; \
	if [ "$$HOSTNAME" = "CT4WL2KYTX" ]; then \
		MOUNT_PATHS=( \
			"/Users/ravinderk/git:/root/git" \
			"/Users/ravinderk/.kube/config:/root/.kube/config" \
			"/Users/ravinderk/.ssh:/root/.ssh" \
			"/Users/ravinderk/.nsk/configuration:/root/.nsk/configuration" \
			"/Users/ravinderk/.config/gh:/root/.config/gh" \
		); \
	elif [ "$$HOSTNAME" = "rk-bastion" ]; then \
		MOUNT_PATHS=( \
			"/home/ravinderk/git:/root/git" \
			"/home/ravinderk/.kube/config:/root/.kube/config" \
			"/home/ravinderk/.ssh:/root/.ssh" \
			"/home/ravinderk/.nsk/configuration:/root/.nsk/configuration" \
			"/home/ravinderk/.config/gh:/root/.config/gh" \
		); \
	else \
		MOUNT_PATHS=( "$$HOME/.ssh:/root/.ssh" ); \
	fi; \
	MANIFEST_FILE=$$(mktemp); \
	VOLUME_MOUNTS=""; \
	VOLUMES=""; \
	for MOUNT in "$${MOUNT_PATHS[@]}"; do \
		HOST_PATH=$$(echo $$MOUNT | cut -d':' -f1); \
		CONTAINER_PATH=$$(echo $$MOUNT | cut -d':' -f2); \
		if [ -e "$$HOST_PATH" ]; then \
			VOLUME_NAME=vol-$$(basename $$HOST_PATH | tr '.' '-' | tr '/' '-'); \
			VOLUME_MOUNTS="$$VOLUME_MOUNTS\n        - mountPath: $$CONTAINER_PATH\n          name: $$VOLUME_NAME"; \
			VOLUMES="$$VOLUMES\n      - name: $$VOLUME_NAME\n        hostPath:\n          path: $$HOST_PATH"; \
		else \
			echo "$$HOST_PATH not found, skipping mount."; \
		fi; \
	done; \
	echo "Generating pod manifest at $$MANIFEST_FILE"; \
	printf "apiVersion: v1\nkind: Pod\nmetadata:\n  name: $(CONTAINER_NAME)\nspec:\n  containers:\n    - name: $(CONTAINER_NAME)\n      image: $(NS_DOCKER_ACCOUNT)/$(IMAGE_NAME):$(IMAGE_VERSION)\n      command: [\"tail\"]\n      args: [\"-f\", \"/dev/null\"]\n      volumeMounts:$${VOLUME_MOUNTS}\n  volumes:$${VOLUMES}\n" > $$MANIFEST_FILE; \
	kubectl apply -f $$MANIFEST_FILE; \
	echo "Waiting for pod $(CONTAINER_NAME) to be ready..."; \
	kubectl wait --for=condition=Ready pod/$(CONTAINER_NAME) --timeout=120s; \
	kubectl exec -it $(CONTAINER_NAME) -- zsh

remove:
	docker rm -f $(CONTAINER_NAME) || true
	@echo "Container $(CONTAINER_NAME) removed."

remove-pod:
	kubectl delete pod $(CONTAINER_NAME) --force || true
	@echo "Pod $(CONTAINER_NAME) removed."

install-nsk:
	@echo "Installing nsk in $(CONTAINER_NAME)"; \
	docker exec -it $(CONTAINER_NAME) bash -c "gh release download v0.1.231 --repo netSkopePlatformEng/nsk --pattern '*amd64.deb' && dpkg -i nsk_0.1.231_linux_amd64.deb"
