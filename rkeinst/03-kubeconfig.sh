#!/bin/bash


# create kubeconfig link
mkdir /home/ec2-user/.kube
ln -s /home/ec2-user/kube_config_cluster.yml /home/ec2-user/.kube/config
chmod 600 /home/ec2-user/.kube/config
