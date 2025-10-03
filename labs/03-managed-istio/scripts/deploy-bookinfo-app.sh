#!/bin/bash

# Variáveis de configuração
NAMESPACE="bookinfo"

# 1. Criar Namespace para a aplicação Bookinfo
echo "Criando o namespace $NAMESPACE..."
kubectl create namespace $NAMESPACE

# 2. Habilitar a injeção automática de sidecar do Istio no namespace
echo "Habilitando a injeção automática de sidecar do Istio no namespace $NAMESPACE..."
kubectl label namespace $NAMESPACE istio-injection=enabled --overwrite

# 3. Implantar a aplicação Bookinfo
echo "Implantando a aplicação Bookinfo no namespace $NAMESPACE..."
kubectl apply -f ../manifests/bookinfo-app.yaml -n $NAMESPACE

echo "Aguardando a aplicação Bookinfo ser implantada..."
kubectl wait --for=condition=available deployment/details-v1 --timeout=300s -n $NAMESPACE
kubectl wait --for=condition=available deployment/ratings-v1 --timeout=300s -n $NAMESPACE
kubectl wait --for=condition=available deployment/productpage-v1 --timeout=300s -n $NAMESPACE
kubectl wait --for=condition=available deployment/reviews-v1 --timeout=300s -n $NAMESPACE
kubectl wait --for=condition=available deployment/reviews-v2 --timeout=300s -n $NAMESPACE
kubectl wait --for=condition=available deployment/reviews-v3 --timeout=300s -n $NAMESPACE

echo "Aplicação Bookinfo implantada com sucesso!"

