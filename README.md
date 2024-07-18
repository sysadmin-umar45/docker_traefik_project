# docker_traefik_project
sudo vim /etc/traefik/traefik.yml
global:
  checkNewVersion: true
  sendAnonymousUsage: false
accessLog:
  filePath: /var/log/traefik/access.log
api:
  dashboard: true
  insecure: true  # Set to false and configure authentication for production
entryPoints:
  web:
    address: ":80"
  websecure:
    address: ":443"
certificatesResolvers:
  letsencrypt:
    acme:
      email: programmingknowledge03@gmail.com
      storage: /letsencrypt/acme.json
      httpChallenge:
        entryPoint: web

providers:
  docker:
    endpoint: "unix:///var/run/docker.sock"
    exposedByDefault: false

sudo vi docker-compose.yml 
version: '3'
volumes:
  traefik-ssl-certs:
    driver: local
services:
  traefik:
    image: traefik:v2.10  # You can use the latest version
    container_name: traefik
    ports:
      - "80:80"         # HTTP port
      - "443:443"       # HTTPS port
      - "8091:8080"     # Dashboard port
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock:ro"
      - "./traefik.toml:/etc/traefik/traefik.toml"
    networks:
      - web

networks:
  web:
    external: false