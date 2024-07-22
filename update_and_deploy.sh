#!/bin/bash
# NOTE: WE WILL KEEP THIS IN ~
# Function to handle errors
handle_error() {
    echo "Error on line $1"
    exit 1
}

# Trap errors and call handle_error
trap 'handle_error $LINENO' ERR

# Update secrets-manager app
echo "Updating secrets-manager app..."
cd secrets-manager || exit
git pull || exit
docker build -t secrets-manager . || exit
cd ..

# Update go sample app
echo "Updating go sample app..."
cd docker_traefik_project || exit
git pull || exit
./build-scratch.sh || exit
cd ..

# Update traefik and run all containers again
echo "Updating Traefik and running all containers..."
cd docker_traefik_project || exit
./update_traefik.sh || exit

echo "Update and deployment completed successfully."
