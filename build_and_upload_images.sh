#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status

# Navigate to the script's directory (ensuring we are in the right place)
cd "$(dirname "$0")"

# Ensure we are in the Docker directory (if applicable)
if [ -d "Docker" ]; then
    cd Docker
fi

# Check if the cluster exists, if not, create it
if ! kind get clusters | grep -q "test-cluster"; then
    echo "Creating kind cluster..."
    kind create cluster --name test-cluster
else
    echo "Kind cluster 'test-cluster' already exists."
fi

# Function to build an image only if it doesn't exist
build_if_not_exist() {
    local image_name="$1"
    local dockerfile="$2"
    
    if ! docker images | grep -q "$image_name"; then
        echo "Building image: $image_name"
        docker build -t "$image_name" -f "$dockerfile" .
    else
        echo "Image $image_name already exists, skipping build."
    fi
}

# Build images in parallel
echo "Building Docker images..."
build_if_not_exist "extract:v1" "Dockerfile.extract" &
build_if_not_exist "transform:v1" "Dockerfile.transform" &
build_if_not_exist "load:v1" "Dockerfile.load" &
wait  # Wait for all parallel jobs to finish

# Load images into kind cluster
echo "Loading images into Kind cluster..."
kind load docker-image extract:v1 --name test-cluster
kind load docker-image transform:v1 --name test-cluster
kind load docker-image load:v1 --name test-cluster

echo "All images have been built and loaded successfully!"
