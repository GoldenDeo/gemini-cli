IMAGE_NAME ?= gemini-cli
DOCKER_REPO ?= your-dockerhub-username
TAG ?= latest
FULL_IMAGE ?= $(DOCKER_REPO)/$(IMAGE_NAME):$(TAG)

# Default config paths
CONFIG_DIR ?= ./config
USER_CONFIG ?= $(CONFIG_DIR)/user-settings.json
PROJECT_CONFIG ?= $(CONFIG_DIR)/project-settings.json
SYSTEM_CONFIG ?= $(CONFIG_DIR)/system-settings.json
MEMORY_FILE ?= $(CONFIG_DIR)/GEMINI.md

.PHONY: build run clean-volumes push login publish setup-config

build:
	docker build -t $(IMAGE_NAME) .
	docker tag $(IMAGE_NAME) $(FULL_IMAGE)

# Create config directory and sample files if they don't exist
setup-config:
	@mkdir -p $(CONFIG_DIR)
	@[ -f $(USER_CONFIG) ] || cp -n settings.json $(USER_CONFIG) 2>/dev/null || echo '{}' > $(USER_CONFIG)
	@[ -f $(PROJECT_CONFIG) ] || cp -n project-settings.json $(PROJECT_CONFIG) 2>/dev/null || echo '{}' > $(PROJECT_CONFIG)
	@[ -f $(SYSTEM_CONFIG) ] || cp -n system-settings.json $(SYSTEM_CONFIG) 2>/dev/null || echo '{}' > $(SYSTEM_CONFIG)
	@[ -f $(MEMORY_FILE) ] || cp -n GEMINI.md $(MEMORY_FILE) 2>/dev/null || echo '# Gemini CLI Context' > $(MEMORY_FILE)
	@echo "Config files prepared in $(CONFIG_DIR) directory"

run: setup-config
	@mkdir -p artifacts
	docker run -it --rm \
		-v $(PWD)/artifacts:/workspace \
		-v gemini-config:/root/.config \
		-v gemini-cache:/root/.cache \
		-v npm-cache:/root/.npm \
		-v $(PWD)/$(USER_CONFIG):/root/.gemini/settings.json \
		-v $(PWD)/$(PROJECT_CONFIG):/workspace/.gemini/settings.json \
		-v $(PWD)/$(SYSTEM_CONFIG):/etc/gemini-cli/settings.json \
		-v $(PWD)/$(MEMORY_FILE):/root/.gemini/GEMINI.md \
		-e GEMINI_API_KEY \
		-e GOOGLE_API_KEY \
		-e GOOGLE_CLOUD_PROJECT \
		-e GOOGLE_CLOUD_LOCATION \
		-e GOOGLE_GENAI_USE_VERTEXAI \
		-e GIT_USER_NAME \
		-e GIT_USER_EMAIL \
		$(IMAGE_NAME) $(ARGS)

# Allow using existing project configs
run-with-project-config:
	@mkdir -p artifacts
	docker run -it --rm \
		-v $(PWD)/artifacts:/workspace \
		-v gemini-config:/root/.config \
		-v gemini-cache:/root/.cache \
		-v npm-cache:/root/.npm \
		-v $(PWD)/artifacts/.gemini:/workspace/.gemini \
		-e GEMINI_API_KEY \
		-e GOOGLE_API_KEY \
		-e GOOGLE_CLOUD_PROJECT \
		-e GOOGLE_CLOUD_LOCATION \
		-e GOOGLE_GENAI_USE_VERTEXAI \
		-e GIT_USER_NAME \
		-e GIT_USER_EMAIL \
		$(IMAGE_NAME) $(ARGS)

run-hub: setup-config
	@mkdir -p artifacts
	docker run -it --rm \
		-v $(PWD)/artifacts:/workspace \
		-v gemini-config:/root/.config \
		-v gemini-cache:/root/.cache \
		-v npm-cache:/root/.npm \
		-v $(PWD)/$(USER_CONFIG):/root/.gemini/settings.json \
		-v $(PWD)/$(PROJECT_CONFIG):/workspace/.gemini/settings.json \
		-v $(PWD)/$(SYSTEM_CONFIG):/etc/gemini-cli/settings.json \
		-v $(PWD)/$(MEMORY_FILE):/root/.gemini/GEMINI.md \
		-e GEMINI_API_KEY \
		-e GOOGLE_API_KEY \
		-e GOOGLE_CLOUD_PROJECT \
		-e GOOGLE_CLOUD_LOCATION \
		-e GOOGLE_GENAI_USE_VERTEXAI \
		-e GIT_USER_NAME \
		-e GIT_USER_EMAIL \
		$(FULL_IMAGE) $(ARGS)

login:
	docker login

push: build
	docker push $(FULL_IMAGE)

publish: login push
	echo "Published $(FULL_IMAGE) to Docker Hub"

clean-volumes:
	docker volume rm gemini-config gemini-cache npm-cache 2>/dev/null || true