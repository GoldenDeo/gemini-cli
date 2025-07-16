# Gemini CLI Docker

Simple Docker setup for Google Gemini CLI - minimalist approach without unnecessary complications.

## Quick Start

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
- `build` - builds Docker image
- `run` - runs with current directory mounted and environment variables passed
- `clean-volumes` - removes all persistent volumes (resets configuration)
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

### Basic usage
```bash
make build
export GOOGLE_API_KEY="your_key"
export GIT_USER_NAME="Your Name"  
export GIT_USER_EMAIL="your@email.com"
make run
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
3. Export it: `export GOOGLE_API_KEY="your_key"`

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
✅ **Git integration** - Configure via environment variables  
✅ **Current directory** - Available as `/workspace`  
✅ **Environment variables** - Automatically passed through  
✅ **Persistent storage** - Config, cache, and artifacts preserved  
✅ **No re-authentication** - Login once, use everywhere

## Examples

```bash
# First run - authenticate once
make run
> (Authentication happens here)

# Subsequent runs - no re-authentication needed!
make run
> Analyze this codebase

# Create a new file  
make run  
> Create a Python script that...

# Work with Git
make run
> Write a commit message for current changes

# Install packages in projects - npm cache persists
make run
> Create a new Node.js project with dependencies
```

Everything simple and it works! 🚀