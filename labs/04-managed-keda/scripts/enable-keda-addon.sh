#!/bin/bash

# Variáveis de configuração
RESOURCE_GROUP="aks-workshop-rg"
AKS_CLUSTER_NAME="aks-workshop-cluster"

echo "Habilitando o add-on KEDA no cluster AKS: $AKS_CLUSTER_NAME..."
az aks update \
    --resource-group $RESOURCE_GROUP \
    --name $AKS_CLUSTER_NAME \
    --enable-keda

echo "Verificando a instalação do KEDA..."
az aks show --resource-group $RESOURCE_GROUP --name $AKS_CLUSTER_NAME --query "workloadAutoScalerProfile.keda.enabled" -o tsv

echo "Verificando os pods do KEDA..."
kubectl get pods -n kube-system -l app.kubernetes.io/name=keda-operator

echo "Add-on KEDA habilitado e verificado com sucesso!"

