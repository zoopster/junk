#!/bin/bash
set -x

# assumption - ec2-user is the default user

#sudo hostnamectl set-hostname rancher1
#sudo reboot

# Create a key - add to authorized_keys
ssh-keygen -b 2048 -t rsa -f /home/ec2-user/.ssh/id_rsa -N ""
cat /home/ec2-user/.ssh/id_rsa.pub >> /home/ec2-user/.ssh/authorized_keys

# we need docker as the current user
sudo usermod -aG docker ec2-user

# Download RKE
sudo wget -O /usr/local/bin/rke \
https://github.com/rancher/rke/releases/download/v1.2.1/rke_linux-amd64
sudo chmod +x /usr/local/bin/rke

# Download kubectl
sudo curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
sudo mv kubectl /usr/local/bin
sudo chmod +x /usr/local/bin/kubectl

# install helm
curl -fsSL https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 |bash
