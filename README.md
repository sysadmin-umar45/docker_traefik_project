# docker_traefik_project
# Run only update_and_deploy script, if you want to work on existing 2 projects
# I you  make any changes in update_and_deploy script
cd ~/docker_traefik_project/ && git reset --hard && git pull 
cd ~/docker_traefik_project/traefik && sudo chmod +x update_and_deploy.sh && sudo ./update_and_deploy.sh



# I you don't make any changes in update_and_deploy script
cd ~/docker_traefik_project/traefik && sudo ./update_and_deploy.sh 

testing webhook 2
