#!/bin/bash

# Variáveis de configuração
RESOURCE_GROUP="aks-workshop-rg"
AKS_CLUSTER_NAME="aks-workshop-cluster"
ACR_NAME="aksworkshopacr$(az acr list --resource-group $RESOURCE_GROUP --query '[0].name' -o tsv)"
IMAGE_NAME="keda-queue-processor"
IMAGE_TAG="latest"
NAMESPACE="keda-app"

# 1. Autenticar no ACR
echo "Autenticando no Azure Container Registry: $ACR_NAME..."
az acr login --name $ACR_NAME

# 2. Construir a imagem Docker
echo "Construindo a imagem Docker para a aplicação de processamento de fila..."
docker build -t $ACR_NAME.azurecr.io/$IMAGE_NAME:$IMAGE_TAG ../../../apps/servicebus-processor

# 3. Fazer push da imagem para o ACR
echo "Fazendo push da imagem para o ACR..."
docker push $ACR_NAME.azurecr.io/$IMAGE_NAME:$IMAGE_TAG

# 4. Criar Namespace para a aplicação
echo "Criando o namespace $NAMESPACE..."
kubectl create namespace $NAMESPACE --dry-run=client -o yaml | kubectl apply -f -

# 5. Implantar a aplicação de processamento de fila
echo "Implantando a aplicação de processamento de fila no namespace $NAMESPACE..."
# Substituir o placeholder da imagem no manifesto antes de aplicar
cat ../manifests/queue-processor-deployment.yaml | \
    sed "s|YOUR_ACR_NAME.azurecr.io/$IMAGE_NAME:$IMAGE_TAG|$ACR_NAME.azurecr.io/$IMAGE_NAME:$IMAGE_TAG|g" | \
    kubectl apply -f - -n $NAMESPACE

echo "Aguardando a aplicação ser implantada..."
kubectl wait --for=condition=available deployment/keda-queue-processor --timeout=300s -n $NAMESPACE

echo "Aplicação de processamento de fila implantada com sucesso!"

