#!/bin/bash


# install rancher
helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
helm repo update
kubectl create ns cattle-system
# helm install rancher rancher-latest/rancher --namespace cattle-system --set hostname=${hostname} --set replicas=1

helm install rancher rancher-latest/rancher \
  --namespace cattle-system \
  --set hostname=rancher.appdel.net \
  --set replicas=1 \
  --set ingress.tls.source=letsEncrypt \
  --set letsEncrypt.email=pepelepugh+le@gmail.com \
  --set letsEncrypt.environment=staging
