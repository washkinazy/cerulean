#!/bin/bash
set -euo pipefail

# Check if image name is provided as an argument
if [ $# -lt 1 ]; then
    echo "Error: No image name provided."
    echo "Usage: $0 <image-name>"
    exit 1
fi

# Variables
IMAGE_NAME="$1"
IMAGE_REPO="ghcr.io/washkinazy"
IMAGE_TAG="latest"
VARIANT="Silverblue"
ISO_NAME="${IMAGE_NAME}-${IMAGE_TAG}-${VARIANT}.iso"

# Execute the podman command with error handling
if ! sudo podman run --rm --privileged \
    --volume "$(pwd)":/build-container-installer/build \
    --security-opt label=disable --pull=newer \
    ghcr.io/jasonn3/build-container-installer:latest \
    IMAGE_REPO="$IMAGE_REPO" \
    IMAGE_NAME="$IMAGE_NAME" \
    IMAGE_TAG="$IMAGE_TAG" \
    VARIANT="$VARIANT" \
    ISO_NAME="$ISO_NAME"; then
    echo "Error: Failed to execute podman container."
    exit 1
fi

echo "Build completed successfully: ${ISO_NAME}"
