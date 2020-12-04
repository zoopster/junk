#!/bin/bash


# create kubeconfig link
mkdir /home/ec2-user/.kube
ln -s /home/ec2-user/kube_config_rancher-cluster.yml /home/ec2-user/.kube/config
chmod g-r /home/ec2-user/.kube/config


