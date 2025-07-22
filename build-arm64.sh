#!/bin/bash
# Build script for ARM64 version of Abiotic Factor Docker container

echo "Building Abiotic Factor Linux Docker container for ARM64..."

# Build the Docker image for ARM64 platform
docker buildx build --platform linux/arm64 -t abiotic-factor-linux-docker:arm64-latest .

echo "Build complete!"
echo "To run the container, use: docker-compose up -d"
echo "Make sure your docker-compose.yml uses the arm64-latest tag"
