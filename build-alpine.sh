#!/bin/bash

# Ensure the script exits if any command fails
set -e

# Name of the output binary
BINARY_NAME=app

# Directory containing the Go source code
SOURCE_DIR=./testApp

# Build the Go application
echo "Building the Go application..."
CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o $BINARY_NAME $SOURCE_DIR/main.go

# Create a Dockerfile
echo "Creating the Dockerfile..."
cat <<EOF > Dockerfile
# Use the Alpine image to build the application
FROM golang:alpine AS builder

# Set the Current Working Directory inside the container
WORKDIR /app

# Copy the source code into the container
COPY $SOURCE_DIR/main.go .

# Build the Go application
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o $BINARY_NAME main.go

# Use the Alpine image for the final build
FROM alpine:latest

# Copy the binary from the builder
COPY --from=builder /app/$BINARY_NAME /usr/local/bin/$BINARY_NAME

# Command to run the binary
ENTRYPOINT ["/usr/local/bin/$BINARY_NAME"]
EOF

# Build the Docker image
echo "Building the Docker image..."
docker build -t go-alpine-app .

# Cleanup
echo "Cleaning up..."
rm $BINARY_NAME
rm Dockerfile

echo "Docker image 'go-alpine-app' created successfully."
