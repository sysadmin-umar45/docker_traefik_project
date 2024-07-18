#!/bin/bash

# Navigate to the project directory
cd /home/ubuntu/docker_traefik_project || { echo "Directory not found"; exit 1; }

# Pull the latest changes from the git repository
git pull || { echo "Git pull failed"; exit 1; }

# Navigate to the Traefik configuration directory
cd ./traefik || { echo "Traefik directory not found"; exit 1; }

# Copy the Traefik configuration file to the appropriate location
sudo cp traefik.yml /etc/traefik/traefik.yml || { echo "Failed to copy traefik.yml"; exit 1; }

# Restart the Docker Compose services
docker-compose down && docker-compose up -d || { echo "Docker Compose failed"; exit 1; }

echo "Traefik and services have been updated and restarted successfully."
