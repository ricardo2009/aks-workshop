#!/bin/bash

# Variáveis de configuração
RESOURCE_GROUP="aks-workshop-rg"
QUEUE_NAME="myqueue"
MESSAGE_COUNT=${1:-10}

# Obter a string de conexão do secret do Kubernetes
CONNECTION_STR=$(kubectl get secret servicebus-secret -n keda-app -o jsonpath=\'{.data.connectionString}\' | base64 --decode)

if [ -z "$CONNECTION_STR" ]; then
    echo "Erro: Secret \'servicebus-secret\' ou connectionString não encontrado no namespace keda-app."
    echo "Certifique-se de ter criado o secret com a string de conexão do Azure Service Bus."
    exit 1
fi

# Extrair o nome do namespace do Service Bus da string de conexão
SERVICEBUS_NAMESPACE=$(echo $CONNECTION_STR | sed -n 's/Endpoint=sb:\/\/\([^.]*\).servicebus.windows.net\/.*/\1/p')

if [ -z "$SERVICEBUS_NAMESPACE" ]; then
    echo "Erro: Não foi possível extrair o nome do namespace do Service Bus da string de conexão."
    exit 1
fi

# Obter o ID da assinatura atual
SUBSCRIPTION_ID=$(az account show --query id -o tsv)

echo "Enviando $MESSAGE_COUNT mensagens para a fila $QUEUE_NAME no namespace $SERVICEBUS_NAMESPACE..."

for i in $(seq 1 $MESSAGE_COUNT);
do
    MESSAGE="Mensagem de teste $i"
    az servicebus queue send \
        --namespace-name $SERVICEBUS_NAMESPACE \
        --queue-name $QUEUE_NAME \
        --resource-group $RESOURCE_GROUP \
        --subscription $SUBSCRIPTION_ID \
        --body "$MESSAGE"
    echo "Mensagem $i enviada: $MESSAGE"
done

echo "Envio de mensagens concluído."

