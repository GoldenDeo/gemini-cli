FROM node:20-slim

# Install git for working with repositories
RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

# Install gemini-cli globally
RUN npm install -g @google/gemini-cli

# Set workdir
WORKDIR /workspace

ENTRYPOINT ["gemini"]
CMD []
