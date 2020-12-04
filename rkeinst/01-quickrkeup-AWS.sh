#!/bin/bash
set -x

#sudo hostnamectl set-hostname rancher1
#sudo reboot

# Create a key - add to authorized_keys
ssh-keygen -b 2048 -t rsa -f /home/ec2-user/.ssh/id_rsa -N ""
cat /home/ec2-user/.ssh/id_rsa.pub >> /home/ec2-user/.ssh/authorized_keys

# Download RKE
sudo wget -O /usr/local/bin/rke \
https://github.com/rancher/rke/releases/download/v1.2.1/rke_linux-amd64
sudo chmod +x /usr/local/bin/rke

# Download kubectl
sudo curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
sudo mv kubectl /usr/local/bin
sudo chmod +x /usr/local/bin/kubectl

# install helm
sudo wget -O helm.tar.gz \
https://get.helm.sh/helm-v3.4.0-linux-amd64.tar.gz
sudo tar -zxf helm.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm
sudo chmod +x /usr/local/bin/helm
sudo rm -rf linux-amd64
sudo rm -f helm.tar.gz

# create cluster.yml
cat << EOF > rancher-cluster.yml
nodes:
  - address: ec2-3-19-246-146-us-east-2.compute.amazonaws.com
    internal_address: $HOST
    user: ec2-user
    role: [controlplane,etcd,worker]
addon_job_timeout: 120
EOF

# bring up rke
rke up --config rancher-cluster.yml

