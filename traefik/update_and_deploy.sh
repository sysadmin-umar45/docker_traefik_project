#!/bin/bash

# Stop script execution on any error
set -e

# Function to handle errors
handle_error() {
    echo "Error on line $1"
    exit 1
}

# Trap errors and call handle_error
trap 'handle_error $LINENO' ERR

# Function to ensure a file has execute permission
ensure_executable() {
    if [ ! -x "$1" ]; then
        echo "Adding execute permissions to $1"
        chmod +x "$1"
    fi
}

# Update secrets-manager app
echo "Updating secrets-manager app..."
cd /home/ubuntu/secrets-manager
git pull
npm install 
npm run build
# Build Docker image
docker build -t secrets-manager .
cd ..

# Update go sample app
echo "Updating go sample app..."
cd /home/ubuntu/docker_traefik_project
git pull
ensure_executable "./build-scratch.sh"
./build-scratch.sh
# Update traefik and run all containers again
echo "Updating Traefik and running all containers..."
ensure_executable "./update_traefik.sh"
./update_traefik.sh

echo "Update and deployment completed successfully."
