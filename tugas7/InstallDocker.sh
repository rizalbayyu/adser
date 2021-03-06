#!/bin/bash
cat << _EOF_
Rizal Bayu Aji Pradana
175150201111051
==============================================================
_EOF_

if [ $EUID -ne 0 ]; then
    echo "This script must be run as root. Please Login as root"
    exit 1
else

cat << _EOF_
Install Docker & Docker Compose
==============================================================
_EOF_

sudo apt update -y && sudo apt install apt-transport-https ca-certificates curl software-properties-common -y

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - && sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"

sudo apt update -y && sudo apt install docker-ce -y

sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo systemctl enable docker
docker network create -d bridge wordpress_network
docker-compose --version
sudo systemctl restart docker

sudo usermod -aG docker ${USER}
su - ${USER}

fi
