#!/usr/bin/env bash

yum update
yum install docker -y
usermod -aG docker ec2-user
systemctl enable docker
systemctl start docker

yum install git -y

cat <<HEREDOC >/root/.ssh/id_rsa
-----BEGIN OPENSSH PRIVATE KEY-----
-----END OPENSSH PRIVATE KEY-----
HEREDOC

chmod 0400 /root/.ssh/id_rsa

mkdir -p /phonebook-react-front

cd phonebook-react-front

ssh-keyscan github.com >>/root/.ssh/known_hosts
git clone git@github.com:ElbrusGarayev/phonebook-react-front.git

cd phonebook-react-front

docker build -t phonebook-frontend-img:v1.0.0 .
docker run -di -e PHONEBOOK_BACKEND_API=${backend_api_url} --name phonebook-frontend -p 3001:3000 phonebook-frontend-img:v1.0.0
