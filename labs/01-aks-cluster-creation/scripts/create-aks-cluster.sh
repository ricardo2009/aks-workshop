#!/bin/bash

# Variáveis de configuração
RESOURCE_GROUP="aks-workshop-rg"
LOCATION="eastus"
AKS_CLUSTER_NAME="aks-workshop-cluster"
ACR_NAME="aksworkshopacr$(date +%s)"

# 1. Criar Grupo de Recursos
echo "Criando o grupo de recursos: $RESOURCE_GROUP na região $LOCATION..."
az group create --name $RESOURCE_GROUP --location $LOCATION

# 2. Criar Azure Container Registry (ACR)
echo "Criando o Azure Container Registry: $ACR_NAME..."
az acr create --resource-group $RESOURCE_GROUP --name $ACR_NAME --sku Basic

# 3. Criar Cluster AKS com Add-ons Gerenciados
echo "Criando o cluster AKS: $AKS_CLUSTER_NAME com add-ons gerenciados..."
az aks create \
    --resource-group $RESOURCE_GROUP \
    --name $AKS_CLUSTER_NAME \
    --node-count 2 \
    --enable-managed-identity \
    --enable-addons monitoring,ingress-nginx,keda,istio \
    --attach-acr $ACR_NAME \
    --generate-ssh-keys \
    --kubernetes-version 1.28.5 \
    --network-plugin azure \
    --network-policy azure \
    --enable-msi-auth-for-monitoring \
    --enable-azure-rbac \
    --load-balancer-sku standard \
    --outbound-type loadbalancer

# 4. Configurar kubectl para acessar o cluster
echo "Configurando kubectl para acessar o cluster AKS..."
az aks get-credentials --resource-group $RESOURCE_GROUP --name $AKS_CLUSTER_NAME --overwrite-existing

echo "Cluster AKS e ACR criados e configurados com sucesso!"

