#!/bin/bash

# Variáveis de configuração
RESOURCE_GROUP="aks-workshop-rg"
AKS_CLUSTER_NAME="aks-workshop-cluster"

echo "Habilitando o add-on Istio no cluster AKS: $AKS_CLUSTER_NAME..."
az aks mesh enable --resource-group $RESOURCE_GROUP --name $AKS_CLUSTER_NAME

echo "Verificando a instalação do Istio..."
az aks show --resource-group $RESOURCE_GROUP --name $AKS_CLUSTER_NAME  --query 'serviceMeshProfile.mode'

echo "Verificando os pods do Istio..."
kubectl get pods -n aks-istio-system

echo "Add-on Istio habilitado e verificado com sucesso!"

