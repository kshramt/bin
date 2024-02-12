#!/bin/bash

# Check if an image name and tag were passed as arguments
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 library/ubuntu:latest"
    echo "Usage: $0 pytorch/pytorch:latest"
    exit 1
fi

IMAGE_NAME_TAG="$1"
# Separate the image name and tag
IMAGE_NAME="${IMAGE_NAME_TAG%:*}"
TAG="${IMAGE_NAME_TAG##*:}"

# Docker Hub specifics
REGISTRY="registry-1.docker.io"
REPO="$IMAGE_NAME"
SERVICE="registry.docker.io"

# Obtain a Bearer Token
TOKEN=$(curl -s "https://auth.docker.io/token?service=$SERVICE&scope=repository:$REPO:pull" | jq -r .token)

# Fetch the Manifest List and its digest
DIGEST=$(curl -s -H "Authorization: Bearer $TOKEN" -H "Accept: application/vnd.docker.distribution.manifest.list.v2+json" -I "https://$REGISTRY/v2/$REPO/manifests/$TAG" | grep "docker-content-digest:" | awk '{print $2}' | tr -d $'\r')

if [ -z "$DIGEST" ]; then
    echo "Failed to fetch the manifest list digest for $IMAGE_NAME_TAG"
    exit 1
else
    echo "Manifest list digest for $IMAGE_NAME_TAG: $DIGEST"
fi
