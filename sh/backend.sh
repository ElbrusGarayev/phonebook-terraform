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

mkdir -p /phonebook-step-app

cd phonebook-step-app

ssh-keyscan github.com >>/root/.ssh/known_hosts
git clone git@github.com:ElbrusGarayev/phonebook-app.git

cd phonebook-step-app

docker build -t phonebook-backend-img:v1.0.0 .
docker run -di -e MYSQL_URL=${mysql_url} -e MYSQL_USERNAME=${mysql_username} -e MYSQL_PASSWORD=${mysql_password} --name phonebook-backend -p 80:80 phonebook-backend-img:v1.0.0
