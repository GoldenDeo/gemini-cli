# Gemini CLI Docker

Simple Docker setup for Google Gemini CLI - minimalist approach without unnecessary complications.

## Quick Start

```bash
# Build the image
make build

# Set API key and run
export GOOGLE_API_KEY="your_api_key_here"
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
- `run` - runs with current directory and Git config mounted

## Usage

### Basic usage
```bash
make build
export GOOGLE_API_KEY="your_key"
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

### Getting API key
1. Go to [Google AI Studio](https://aistudio.google.com/apikey)
2. Create an API key
3. Export it: `export GOOGLE_API_KEY="your_key"`


## Examples

```bash
# Analyze current directory
make run
> Analyze this codebase

# Create a new file
make run  
> Create a Python script that...

# Work with Git
make run
> Write a commit message for current changes
```