#!/bin/bash

# Variáveis de configuração
RESOURCE_GROUP="aks-workshop-rg"
AKS_CLUSTER_NAME="aks-workshop-cluster"

echo "Verificando o status do add-on NGINX Ingress Controller no cluster AKS: $AKS_CLUSTER_NAME..."

# O NGINX Ingress Controller é habilitado como um add-on na criação do cluster.
# Vamos apenas verificar se ele está ativo e obter seu IP externo.

INGRESS_ENABLED=$(az aks show --resource-group $RESOURCE_GROUP --name $AKS_CLUSTER_NAME --query "addonProfiles.ingressNginx.enabled" -o tsv)

if [ "$INGRESS_ENABLED" == "true" ]; then
    echo "Add-on NGINX Ingress Controller está habilitado."
else
    echo "Erro: Add-on NGINX Ingress Controller não está habilitado. Por favor, verifique a criação do cluster."
    exit 1
fi

echo "Verificando os pods do NGINX Ingress Controller..."
kubectl get pods -n ingress-nginx -l app.kubernetes.io/name=ingress-nginx

echo "Obtendo o IP externo do NGINX Ingress Controller..."
EXTERNAL_IP=$(kubectl get service ingress-nginx-controller -n ingress-nginx -o jsonpath="{.status.loadBalancer.ingress[0].ip}")

if [ -z "$EXTERNAL_IP" ]; then
    echo "Aguardando o IP externo do NGINX Ingress Controller ser provisionado..."
    # Loop para aguardar o IP externo
    for i in {1..30};
    do
        EXTERNAL_IP=$(kubectl get service ingress-nginx-controller -n ingress-nginx -o jsonpath="{.status.loadBalancer.ingress[0].ip}")
        if [ ! -z "$EXTERNAL_IP" ]; then
            break
        fi
        sleep 10
    done
fi

if [ -z "$EXTERNAL_IP" ]; then
    echo "Erro: Não foi possível obter o IP externo do NGINX Ingress Controller."
    exit 1
else
    echo "IP Externo do NGINX Ingress Controller: $EXTERNAL_IP"
fi

echo "Add-on NGINX Ingress Controller verificado com sucesso!"

