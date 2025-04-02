#!/bin/bash

# Build Docker images
docker build -t outlier-detection:v1 -f Dockerfile.outlier_detection_v1 .
docker build -t outlier-detection:v2 -f Dockerfile.outlier_detection_v2 .

# Load Docker images into kind cluster
kind load docker-image outlier-detection:v1 --name test-cluster
kind load docker-image outlier-detection:v2 --name test-cluster
