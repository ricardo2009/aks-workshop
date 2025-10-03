#!/bin/bash

# Variáveis de configuração
RESOURCE_GROUP="aks-workshop-rg"
LOCATION="eastus"
AKS_CLUSTER_NAME="aks-workshop-cluster"
GRAFANA_NAME="aksworkshopgrafana$(date +%s)"

# 1. Habilitar o add-on de monitoramento no AKS (já feito na criação do cluster, mas pode ser re-executado para garantir)
echo "Habilitando/Verificando o add-on de monitoramento no cluster AKS: $AKS_CLUSTER_NAME..."
az aks update \
    --resource-group $RESOURCE_GROUP \
    --name $AKS_CLUSTER_NAME \
    --enable-managed-prometheus \
    --enable-msi-auth-for-monitoring

# 2. Criar uma instância do Azure Managed Grafana
echo "Criando instância do Azure Managed Grafana: $GRAFANA_NAME..."
az grafana create \
    --resource-group $RESOURCE_GROUP \
    --name $GRAFANA_NAME \
    --location $LOCATION \
    --sku Standard

echo "Aguardando a criação da instância do Grafana..."
az grafana show --resource-group $RESOURCE_GROUP --name $GRAFANA_NAME --query provisioningState -o tsv

# 3. Obter o ID do Workspace do Azure Monitor (criado automaticamente com o Managed Prometheus)
# É necessário um pequeno delay para que o workspace seja provisionado e detectável
echo "Aguardando o provisionamento do Workspace do Azure Monitor..."
sleep 60 # Espera 60 segundos para o workspace ser provisionado

MONITOR_WORKSPACE_ID=$(az monitor account show \
    --resource-group $RESOURCE_GROUP \
    --name "DefaultAzureMonitorWorkspace-"$LOCATION \
    --query id -o tsv)

if [ -z "$MONITOR_WORKSPACE_ID" ]; then
    echo "Erro: Não foi possível obter o ID do Workspace do Azure Monitor. Verifique se o Managed Prometheus foi habilitado corretamente."
    exit 1
fi

echo "ID do Workspace do Azure Monitor: $MONITOR_WORKSPACE_ID"

# 4. Conectar o Azure Managed Grafana ao Azure Monitor Workspace
echo "Conectando Azure Managed Grafana ao Azure Monitor Workspace..."
az grafana update \
    --resource-group $RESOURCE_GROUP \
    --name $GRAFANA_NAME \
    --workspace-id $MONITOR_WORKSPACE_ID

echo "Azure Managed Prometheus e Grafana configurados com sucesso!"

echo "Para acessar o Grafana, execute: az grafana show --resource-group $RESOURCE_GROUP --name $GRAFANA_NAME --query "properties.url" -o tsv"

