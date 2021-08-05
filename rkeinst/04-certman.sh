#!/bin/bash

# install cert-manager
kubectl create ns cert-manager
helm repo add jetstack https://charts.jetstack.io
helm repo update

helm install cert-manager jetstack/cert-manager \
--namespace cert-manager \
--version v1.2.0 \
--set installCRDs=true
