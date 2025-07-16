IMAGE_NAME ?= gemini-cli

.PHONY: build run

build:
    docker build -t $(IMAGE_NAME) .

run:
    docker run -it --rm \
        -v $(PWD):/workspace \
        -v $(HOME)/.gitconfig:/root/.gitconfig:ro \
        -e GEMINI_API_KEY \
        -e GOOGLE_API_KEY \
        -e GOOGLE_CLOUD_PROJECT \
        -e GOOGLE_CLOUD_LOCATION \
        -e GOOGLE_GENAI_USE_VERTEXAI \
        $(IMAGE_NAME) $(ARGS)
