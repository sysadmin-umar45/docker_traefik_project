# docker_traefik_project
sudo vim /etc/traefik/traefik.yml
sudo vi docker-compose.yml 
docker run -d \
  --name nginx \
  -l "traefik.enable=true" \
  -l "traefik.http.routers.nginx.entrypoints=web" \
  -l 'traefik.http.routers.nginx.rule=Host("traefik.ayetu.net")' \
  -l "traefik.http.services.nginx.loadbalancer.server.port=80" \
  nginx

# secure trafic
docker run -d \
  --name nginx \
  -l "traefik.enable=true" \
  -l 'traefik.http.routers.nginx.rule=Host(`traefik.ayetu.net`)' \
  -l "traefik.http.services.nginx.loadbalancer.server.port=80" \
  -l "traefik.http.routers.nginx.entrypoints=web" \
  -l "traefik.http.routers.nginx.entrypoints=websecure" \
  -l "traefik.http.routers.nginx.tls=true" \
  -l "traefik.http.routers.nginx.tls.certresolver=production" \
  nginx


cd /var/lib/docker/volumes