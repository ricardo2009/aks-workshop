#!/bin/bash

# Variáveis de configuração
NAMESPACE="prometheus-app"

# 1. Criar Namespace para a aplicação
echo "Criando o namespace $NAMESPACE..."
kubectl create namespace $NAMESPACE

# 2. Implantar a aplicação de exemplo com métricas Prometheus
echo "Implantando a aplicação de exemplo com métricas Prometheus no namespace $NAMESPACE..."
kubectl apply -f ../manifests/prometheus-exporter-app.yaml -n $NAMESPACE

echo "Aguardando a aplicação ser implantada..."
kubectl wait --for=condition=available deployment/prometheus-app --timeout=300s -n $NAMESPACE

echo "Aplicação de exemplo com métricas Prometheus implantada com sucesso!"

