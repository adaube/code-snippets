# Docker Stuff

## install docker 
curl -sSL https://get.docker.com/ | sudo sh
## USER add to docker group
sudo usermod -aG docker $USER
## JENKINS add to docker group
sudo usermod -aG docker jenkins
## JENKINS group check
groups jenkins
## install docker compose
sudo curl -L https://github.com/docker/compose/releases/download/1.16.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
### add executable permissions
sudo chmod +x /usr/local/bin/docker-compose
## check docker-compose functionality
docker-compose --version
