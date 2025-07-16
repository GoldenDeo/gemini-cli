# Gemini CLI Docker

Simple Docker setup for Google Gemini CLI - minimalist approach without unnecessary complications.

## Quick Start (using Docker Hub)

```bash
# Just run without building (fastest way)
export GOOGLE_API_KEY="your_api_key_here"
export GIT_USER_NAME="Your Name"
export GIT_USER_EMAIL="your@email.com"
docker run -it --rm \
  -v $(pwd)/artifacts:/workspace \
  -v gemini-config:/root/.config \
  -v gemini-cache:/root/.cache \
  -v npm-cache:/root/.npm \
  -e GOOGLE_API_KEY \
  -e GIT_USER_NAME \
  -e GIT_USER_EMAIL \
  your-dockerhub-username/gemini-cli
```

## Quick Start (building locally)

```bash
# Build the image
make build

# Set API key and Git config
export GOOGLE_API_KEY="your_api_key_here"
export GIT_USER_NAME="Your Name"
export GIT_USER_EMAIL="your@email.com"
make run
```

## Files

### Dockerfile
- `FROM node:20-slim` - minimal base image
- Installs `git` for repository work
- Installs `@google/gemini-cli` globally
- `WORKDIR /workspace` - working directory
- `ENTRYPOINT ["gemini"]` - direct launch

### Makefile
- `build` - builds Docker image and tags for Docker Hub
- `run` - runs locally built image with `artifacts/` directory mounted
- `run-hub` - runs image from Docker Hub
- `login` - login to Docker Hub
- `push` - builds and pushes to Docker Hub
- `publish` - login + push in one command
- `clean-volumes` - removes all persistent volumes (resets configuration)
- Automatically creates `artifacts/` directory for workspace
- Preserves Gemini CLI configuration, cache, and npm artifacts between runs

## Persistent Storage

The setup uses Docker volumes to preserve important data between container runs:

- `gemini-config` - Gemini CLI configuration and authentication
- `gemini-cache` - Gemini CLI cache for faster responses
- `npm-cache` - npm cache for faster package installations

This means your authentication and preferences persist across sessions!

### Reset configuration
If you need to start fresh:
```bash
make clean-volumes
```

## Usage

### Using from Docker Hub (recommended)
```bash
# Set your environment variables
export GOOGLE_API_KEY="your_key"
export GIT_USER_NAME="Your Name"  
export GIT_USER_EMAIL="your@email.com"

# Run directly from Docker Hub
make run-hub DOCKER_REPO=your-dockerhub-username

# Or run manually:
docker run -it --rm \
  -v $(pwd)/artifacts:/workspace \
  -v gemini-config:/root/.config \
  -v gemini-cache:/root/.cache \
  -v npm-cache:/root/.npm \
  -e GOOGLE_API_KEY \
  -e GIT_USER_NAME \
  -e GIT_USER_EMAIL \
  your-dockerhub-username/gemini-cli
```

### Building locally
```bash
make build
export GOOGLE_API_KEY="your_key"
export GIT_USER_NAME="Your Name"  
export GIT_USER_EMAIL="your@email.com"
make run
```

### Publishing to Docker Hub

1. **Set your Docker Hub username:**
```bash
export DOCKER_REPO=your-dockerhub-username
# or edit Makefile and change DOCKER_REPO variable
```

2. **Publish:**
```bash
# Login and push in one command
make publish DOCKER_REPO=your-dockerhub-username

# Or step by step:
make login           # Login to Docker Hub
make push           # Build and push
```

3. **Multi-platform build (optional):**
```bash
# For ARM64 + AMD64 support
docker buildx create --use
docker buildx build --platform linux/amd64,linux/arm64 \
  -t your-dockerhub-username/gemini-cli:latest \
  --push .
```

### With additional arguments
```bash
make run ARGS="--help"
```

### Environment variables
Makefile automatically passes these variables to the container:
- `GEMINI_API_KEY`
- `GOOGLE_API_KEY`
- `GOOGLE_CLOUD_PROJECT`
- `GOOGLE_CLOUD_LOCATION`
- `GOOGLE_GENAI_USE_VERTEXAI`
- `GIT_USER_NAME` - your Git username
- `GIT_USER_EMAIL` - your Git email

### Getting API key
1. Go to [Google AI Studio](https://aistudio.google.com/apikey)
2. Create an API key
3. Export it: `export GEMINI_API_KEY="your_key"`

### Git configuration
Set your Git identity via environment variables:
```bash
export GIT_USER_NAME="Your Name"
export GIT_USER_EMAIL="your@email.com"
```

Or configure Git inside the container (persists in volumes):
```bash
make run
# Inside container:
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
```

## Features

✅ **Minimalism** - Only what's necessary, nothing extra  
✅ **Docker Hub ready** - Easy distribution and instant usage  
✅ **Git integration** - Configure via environment variables  
✅ **Clean workspace** - Uses `artifacts/` directory as `/workspace`  
✅ **Environment variables** - Automatically passed through  
✅ **Persistent storage** - Config, cache, and artifacts preserved  
✅ **No re-authentication** - Login once, use everywhere  
✅ **Multi-platform** - Supports AMD64 and ARM64 architectures

## Examples

### Using Docker Hub image (no build required)
```bash
# Quick start with Docker Hub
export GOOGLE_API_KEY="your_key"
docker run -it --rm \
  -v $(pwd)/artifacts:/workspace \
  -v gemini-config:/root/.config \
  -e GOOGLE_API_KEY \
  your-dockerhub-username/gemini-cli

# First run - authenticate once
> (Authentication happens here)

# Create a new project
> Create a Python web scraper that extracts article titles
```

### Local development workflow
```bash
# First run - authenticate once
make run
> (Authentication happens here)

# Subsequent runs - no re-authentication needed!
make run
> Analyze this codebase

# Create a new file (saved to artifacts/ directory)
make run  
> Create a Python script that...

# Work with Git projects in artifacts/
make run
> Write a commit message for current changes

# Install packages in projects - npm cache persists
make run
> Create a new Node.js project with dependencies
```

## Working Directory

All Gemini CLI work happens in the `artifacts/` directory:
- Generated files appear in `./artifacts/`
- Git repositories should be cloned into `./artifacts/`
- Projects are created in `./artifacts/`
- This keeps your main project directory clean!

## Configuration Files

This Docker setup supports all Gemini CLI configuration files in a structured way.

### Configuration Directory

All configuration files are stored in the `./config` directory (created automatically):

```
config/
  ├── user-settings.json    # User-level settings
  ├── project-settings.json # Project-level settings  
  ├── system-settings.json  # System-level settings
  └── GEMINI.md             # Memory/context file
```

The `setup-config` target creates this directory structure and populates it with default files if they don't exist.

### Using Configuration Files

When running with the default configuration:

```bash
make run
```

This automatically sets up the config directory, mounts the configuration files, and starts Gemini CLI.

### Using Custom Configuration Paths

You can specify custom paths for configuration files:

```bash
make run CONFIG_DIR=./my-configs USER_CONFIG=./special-settings.json MEMORY_FILE=./instructions.md
```

### Using Existing Project Configuration

If you're working with a project that already has its own `.gemini` configuration:

```bash
make run-with-project-config
```

This mounts your project's `.gemini` directory directly, preserving any existing configuration.

### Direct Docker Usage

Or when running directly with Docker:

```bash
docker run -it --rm \
  -v $(pwd)/artifacts:/workspace \
  -v gemini-config:/root/.config \
  -v gemini-cache:/root/.cache \
  -v npm-cache:/root/.npm \
  -v $(pwd)/config/user-settings.json:/root/.gemini/settings.json \
  -v $(pwd)/config/project-settings.json:/workspace/.gemini/settings.json \
  -v $(pwd)/config/system-settings.json:/etc/gemini-cli/settings.json \
  -v $(pwd)/config/GEMINI.md:/root/.gemini/GEMINI.md \
  -e GOOGLE_API_KEY="your_key_here" \
  your-dockerhub-username/gemini-cli
```