# docker_traefik_project
sudo vim /etc/traefik/traefik.yml
sudo cp /home/ubuntu/docker_traefik_project/traefik/traefik.yml /etc/traefik/traefik.yml
cat /etc/traefik/traefik.yml
sudo vi docker-compose.yml 
docker-compose up -d
<!-- docker run -d \
  --name nginx \
  --network traefik_web \
  -l "traefik.enable=true" \
  -l "traefik.http.routers.nginx.entrypoints=web" \
  -l 'traefik.http.routers.nginx.rule=Host("traefik.ayetu.net")' \
  -l "traefik.http.services.nginx.loadbalancer.server.port=80" \
  nginx -->

# secure trafic for nginx container
docker run -d \
  --name nginx \
  --network traefik_web \
  -l "traefik.enable=true" \
  -l 'traefik.http.routers.nginx.rule=Host("traefik.ayetu.net")' \
  -l "traefik.http.services.nginx.loadbalancer.server.port=80" \
  -l "traefik.http.routers.nginx.entrypoints=web" \
  -l "traefik.http.routers.nginx.entrypoints=websecure" \
  -l "traefik.http.routers.nginx.tls=true" \
  -l "traefik.http.routers.nginx.tls.certresolver=production" \
  nginx
# secure trafic for go-scratch-app container
docker run -d \
  --name go-scratch-app \
  --network traefik_web \
  -e NAME=Will \
  -p 8081:8080 \
  -e "traefik.enable=true" \
  -e "traefik.http.routers.go-scratch-app.rule=Host("traefik.ayetu.net")" \
  -e "traefik.http.services.go-scratch-app.loadbalancer.server.port=8081" \
  -e "traefik.http.routers.go-scratch-app.entrypoints=web,websecure" \
  -e "traefik.http.routers.go-scratch-app.tls=true" \
  -e "traefik.http.routers.go-scratch-app.tls.certresolver=production" \
  go-scratch-app


cd /var/lib/docker/volumes
docker restart go-scratch-app

docker restart nginx
docker restart traefik
docker stop $(docker ps -q)
cmd := exec.Command("docker", "run", "-d", "--name", "go-scratch-app-container", "-p", "8080:8080", "-e", "NAME=Will", "go-scratch-app")


cd /home/ubuntu/docker_traefik_project && git pull && cd ./traefik && docker-compose down && docker-compose up -d