#!/bin/bash
set -x

helm repo add suse https://kubernetes-charts.suse.com
helm search repo suse

kubectl create ns cfo
helm install cf-operator suse/cf-operator \
--namespace cfo \
--set "global.operator.watchNamespace=kubecf"
