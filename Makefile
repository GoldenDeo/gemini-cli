IMAGE_NAME ?= gemini-cli
DOCKER_REPO ?= your-dockerhub-username
TAG ?= latest
FULL_IMAGE ?= $(DOCKER_REPO)/$(IMAGE_NAME):$(TAG)

.PHONY: build run clean-volumes push login publish
build:
	docker build -t $(IMAGE_NAME) .
	docker tag $(IMAGE_NAME) $(FULL_IMAGE)
run:
	@mkdir -p artifacts
	docker run -it --rm \
		-v $(PWD)/artifacts:/workspace \
		-v gemini-config:/root/.config \
		-v gemini-cache:/root/.cache \
		-v npm-cache:/root/.npm \
		-e GEMINI_API_KEY \
		-e GOOGLE_API_KEY \
		-e GOOGLE_CLOUD_PROJECT \
		-e GOOGLE_CLOUD_LOCATION \
		-e GOOGLE_GENAI_USE_VERTEXAI \
		-e GIT_USER_NAME \
		-e GIT_USER_EMAIL \
		$(IMAGE_NAME) $(ARGS)
run-hub:
	@mkdir -p artifacts
	docker run -it --rm \
		-v $(PWD)/artifacts:/workspace \
		-v gemini-config:/root/.config \
		-v gemini-cache:/root/.cache \
		-v npm-cache:/root/.npm \
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