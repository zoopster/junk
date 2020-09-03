#!/bin/bash
set -x

helm install stable/nfs-client-provisioner --name nfs-client --set nfs.server=rmt.example.com --nfs.path=/export --set storageClass.defaultClass=true
