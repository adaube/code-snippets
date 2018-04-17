# Docker Stuff

## install docker 
curl -sSL https://get.docker.com/ | sudo sh

## add user to docker group (requires logging back in to work)
sudo usermod -aG docker $USER

## add jenkins to docker
sudo usermod -aG docker jenkins

## check groups for jenkins to make sure docker is there
groups jenkins

## install docker compose
sudo curl -L https://github.com/docker/compose/releases/download/1.16.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose version
