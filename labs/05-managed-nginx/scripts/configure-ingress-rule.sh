#!/bin/bash

# Variáveis de configuração
NAMESPACE="nginx-app"

echo "Aplicando a regra de Ingress para a aplicação web no namespace $NAMESPACE..."
kubectl apply -f ../manifests/nginx-ingress-rule.yaml -n $NAMESPACE

echo "Regra de Ingress aplicada com sucesso!"

echo "Para acessar a aplicação, obtenha o IP externo do NGINX Ingress Controller e configure seu DNS ou arquivo hosts para apontar webapp.aks-workshop.com para este IP."

EXTERNAL_IP=$(kubectl get service ingress-nginx-controller -n ingress-nginx -o jsonpath="{.status.loadBalancer.ingress[0].ip}")

if [ -z "$EXTERNAL_IP" ]; then
    echo "Erro: Não foi possível obter o IP externo do NGINX Ingress Controller. Verifique o status do serviço ingress-nginx-controller no namespace ingress-nginx."
else
    echo "IP Externo do NGINX Ingress Controller: $EXTERNAL_IP"
    echo "Adicione a seguinte entrada ao seu arquivo hosts (ou configure seu DNS):"
    echo "$EXTERNAL_IP    webapp.aks-workshop.com"
fi

