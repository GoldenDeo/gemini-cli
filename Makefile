IMAGE_NAME ?= gemini-cli

.PHONY: build run clean-volumes
build:
	docker build -t $(IMAGE_NAME) .
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
clean-volumes:
	docker volume rm gemini-config gemini-cache npm-cache 2>/dev/null || true