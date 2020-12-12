#!/bin/bash

  sudo yum update -y
  sudo yum install -y docker
  sudo usermod -aG docker ec2-user
  sudo service docker start
  sudo systemctl enable docker
  sudo docker run -d  --name node-exporter  -p 9100:9100  prom/node-exporter
  sudo docker pull redis
  sudo yum install python-pip -y
  pip install docker-py  --user
  sudo -i
  echo "ec2-user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
  exit