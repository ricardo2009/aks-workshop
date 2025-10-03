#!/bin/bash

# Variáveis de configuração
NAMESPACE="nginx-app"

# 1. Criar Namespace para a aplicação
echo "Criando o namespace $NAMESPACE..."
kubectl create namespace $NAMESPACE --dry-run=client -o yaml | kubectl apply -f -

# 2. Implantar a aplicação web de exemplo
echo "Implantando a aplicação web de exemplo no namespace $NAMESPACE..."
kubectl apply -f ../manifests/web-app-deployment.yaml -n $NAMESPACE

echo "Aguardando a aplicação ser implantada..."
kubectl wait --for=condition=available deployment/web-app --timeout=300s -n $NAMESPACE

echo "Aplicação web de exemplo implantada com sucesso!"

