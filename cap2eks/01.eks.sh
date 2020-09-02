#!/bin/bash
set -x
#install script for eksctl

#install aws cli v2
#curl -o awscli-exe-linux-x86_64.zip  "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip
#unzip awscliv2.zip
#sudo ./aws/install

#Install eksctl
#curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" |tar xz -C /tmp
#mv /tmp/eksctl /usr/local/bin

#set variables
source env.sh

#create a cluster
eksctl create cluster --name kubecf --version 1.15 \
--nodegroup-name standard-workers --node-type $NODE_TYPE \
--nodes $NODE_NUM --node-volume-size 80 \
--region $REGION --managed \
--ssh-access --ssh-public-key $SSH_KEY
