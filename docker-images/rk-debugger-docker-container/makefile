SHELL := /bin/bash

# Variables
IMAGE_NAME := rk-debugger
IMAGE_VERSION := 5.0.0
DOCKERFILE := Dockerfile
CONTAINER_NAME := rk-debugger-container
PERSONAL_DOCKER_ACCOUNT := rinku562
NS_DOCKER_ACCOUNT := artifactory.netskope.io/ep-tools-docker
DOCKER_USERNAME ?= rinku562
DOCKER_PASSWORD ?= $(shell echo $$DOCKER_PASSWORD)

# Targets
.PHONY: build run

build:
	docker build --platform linux/amd64 -t $(IMAGE_NAME):$(IMAGE_VERSION) -f $(DOCKERFILE) .
	docker tag $(IMAGE_NAME):$(IMAGE_VERSION) $(PERSONAL_DOCKER_ACCOUNT)/$(IMAGE_NAME):$(IMAGE_VERSION)
	docker tag $(IMAGE_NAME):$(IMAGE_VERSION) $(NS_DOCKER_ACCOUNT)/$(IMAGE_NAME):$(IMAGE_VERSION)

ns-push:
	jf config use rtf-admin
	jf docker push $(NS_DOCKER_ACCOUNT)/$(IMAGE_NAME):$(IMAGE_VERSION)

personal-push:
	# export DOCKER_PASSWORD="fled**"; make personal-push
	echo "$(DOCKER_PASSWORD)" | docker login -u $(DOCKER_USERNAME) --password-stdin
	docker push $(PERSONAL_DOCKER_ACCOUNT)/$(IMAGE_NAME):$(IMAGE_VERSION)

docker-run: docker-remove
	docker run -d --name $(CONTAINER_NAME) $(IMAGE_NAME):$(IMAGE_VERSION)
	docker exec -it $(CONTAINER_NAME) /bin/zsh

docker-run-with-mount: docker-remove
	@echo "--- Determining local system paths based on user's home directory ---"; \
	MOUNT_PATHS=( \
		"$$(echo $$HOME)/git:/root/git" \
		"$$(echo $$HOME)/.kube/config:/root/.kube/config" \
		"$$(echo $$HOME)/.ssh:/root/.ssh" \
		"$$(echo $$HOME)/.nsk/configuration:/root/.nsk/configuration" \
		"$$(echo $$HOME)/.config/gh:/root/.config/gh" \
	); \
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
	echo "Running: docker run -d --name $(CONTAINER_NAME) $$MOUNT_OPTS $(PERSONAL_DOCKER_ACCOUNT)/$(IMAGE_NAME):$(IMAGE_VERSION)"; \
	docker run -d --name $(CONTAINER_NAME) $$MOUNT_OPTS $(PERSONAL_DOCKER_ACCOUNT)/$(IMAGE_NAME):$(IMAGE_VERSION); \
	docker exec -it $(CONTAINER_NAME) zsh

k8s-run-with-mount: k8s-run
	@echo "--- Determining local system paths based on user's home directory ---"; \
	REQUIRED_POD_DIRS=( \
    "/root/git" \
    "/root/.kube" \
    "/root/.ssh" \
    "/root/.nsk" \
    "/root/.config/gh" \
	); \
	echo "Required directories in Pod: $${REQUIRED_POD_DIRS[@]}"; \
	echo "--- Creating directories in Pod if they do not exist ---"; \
	for DIR in "$${REQUIRED_POD_DIRS[@]}"; do \
		echo "Creating directory '$$DIR' in Pod '$(CONTAINER_NAME)'..."; \
		kubectl exec "$(CONTAINER_NAME)" -- mkdir -p "$$DIR"; \
	done; \
	COPY_MAPPINGS=( \
		"$$(echo $$HOME)/.kube/config:/root/.kube/config" \
		"$$(echo $$HOME)/.ssh:/root/.ssh" \
		"$$(echo $$HOME)/.nsk/configuration:/root/.nsk/configuration" \
		"$$(echo $$HOME)/.config/gh:/root/.config/gh" \
	); \
	for MAPPING in "$${COPY_MAPPINGS[@]}"; do \
		LOCAL_SOURCE=$$(echo $$MAPPING | cut -d':' -f1); \
		CONTAINER_DEST=$$(echo $$MAPPING | cut -d':' -f2); \
		\
		if [ -e "$$LOCAL_SOURCE" ]; then \
			echo "Executing: kubectl cp \"$$LOCAL_SOURCE\" \"$(CONTAINER_NAME):$$CONTAINER_DEST\""; \
			kubectl cp "$$LOCAL_SOURCE" "$(CONTAINER_NAME):$$CONTAINER_DEST"; \
		else \
			echo "Warning: Source path '$$LOCAL_SOURCE' not found. Skipping copy."; \
		fi; \
	done; \
	\
	echo ""; \
	echo "--- All copy operations to Pod complete ---"


k8s-run: k8s-remove
	kubectl run $(CONTAINER_NAME) --image=$(NS_DOCKER_ACCOUNT)/$(IMAGE_NAME):$(IMAGE_VERSION) --restart=Never --dry-run=client -o yaml | \
	kubectl apply -f - && \
	kubectl wait --for=condition=Ready pod/$(CONTAINER_NAME) --timeout=300s

k8s-runi: k8s-run
	kubectl exec -it $(CONTAINER_NAME) -- /bin/zsh

docker-remove:
	docker rm -f $(CONTAINER_NAME) || true
	@echo "Container $(CONTAINER_NAME) removed."

k8s-remove:
	kubectl delete pod $(CONTAINER_NAME) --force || true
	@echo "Pod $(CONTAINER_NAME) removed."

docker-install-nsk:
	@echo "Installing nsk in $(CONTAINER_NAME)"; \
	docker exec -it $(CONTAINER_NAME) bash -c "gh release download v0.1.231 --repo netSkopePlatformEng/nsk --pattern '*amd64.deb' && dpkg -i nsk_0.1.231_linux_amd64.deb"
