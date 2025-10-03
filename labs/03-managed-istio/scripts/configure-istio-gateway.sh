#!/bin/bash

# Variáveis de configuração
NAMESPACE="bookinfo"

echo "Aplicando Gateway e VirtualService do Istio para a aplicação Bookinfo no namespace $NAMESPACE..."
kubectl apply -f ../manifests/bookinfo-gateway.yaml -n $NAMESPACE

echo "Aplicando DestinationRules do Istio para a aplicação Bookinfo no namespace $NAMESPACE..."
kubectl apply -f ../manifests/destination-rules.yaml -n $NAMESPACE

echo "Configuração do Gateway e VirtualService do Istio aplicada com sucesso!"

echo "Para acessar a aplicação, obtenha o IP externo do Istio Ingress Gateway:"
kubectl get svc istio-ingressgateway -n aks-istio-system

