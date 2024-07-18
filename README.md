# docker_traefik_project
sudo vim /etc/traefik/traefik.yml
sudo vi docker-compose.yml 
docker run -d \
  --name go-scratch-app \
  -l "traefik.enable=true" \
  -l "traefik.http.routers.go-scratch-app.entrypoints=web" \
  -l 'traefik.http.routers.go-scratch-app.rule=Host("traefik.ayetu.net")' \
  -l "traefik.http.services.go-scratch-app.loadbalancer.server.port=80" \
  go-scratch-app

# secure trafic
docker run -d \
  --name go-scratch-app \
  -l "traefik.enable=true" \
  -l 'traefik.http.routers.go-scratch-app.rule=Host(`traefik.ayetu.net`)' \
  -l "traefik.http.services.go-scratch-app.loadbalancer.server.port=80" \
  -l "traefik.http.routers.go-scratch-app.entrypoints=web" \
  -l "traefik.http.routers.go-scratch-app.entrypoints=websecure" \
  -l "traefik.http.routers.go-scratch-app.tls=true" \
  -l "traefik.http.routers.go-scratch-app.tls.certresolver=production" \
  go-scratch-app


cd /var/lib/docker/volumes