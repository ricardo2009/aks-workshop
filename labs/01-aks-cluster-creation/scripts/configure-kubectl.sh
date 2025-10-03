#!/bin/bash

# Variáveis de configuração
RESOURCE_GROUP="aks-workshop-rg"
AKS_CLUSTER_NAME="aks-workshop-cluster"

# Configurar kubectl para acessar o cluster
echo "Configurando kubectl para acessar o cluster AKS..."
az aks get-credentials --resource-group $RESOURCE_GROUP --name $AKS_CLUSTER_NAME --overwrite-existing

echo "kubectl configurado com sucesso!"

