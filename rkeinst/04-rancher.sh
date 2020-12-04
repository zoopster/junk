#!/bin/bash


# install rancher
helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
helm repo update
kubectl create ns cattle-system
helm install rancher rancher-latest/rancher --namespace cattle-system --set hostname=ec2-3-19-246-146.us-east-2.compute.amazonaws.com --set replicas=1

