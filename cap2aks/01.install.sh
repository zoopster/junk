#!/bin/bash
set -x

source env.sh

# login first
az login

# create resource group in eastus location
az group create --name $RG_NAME --location $REGION

# create aks using managed identity (takes a bit)
az aks create -g $RG_NAME -n $AKS_NAME --enable-managed-identity

# Get credentials
az aks get-credentials --resource-group $RG_NAME --name $AKS_NAME
