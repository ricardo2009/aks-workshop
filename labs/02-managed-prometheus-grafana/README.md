# Lab 02: Monitoramento com Azure Managed Prometheus e Grafana

## Objetivo

Este laboratório tem como objetivo guiar o aluno na habilitação e configuração do Azure Monitor Managed Service para Prometheus e Azure Managed Grafana para monitorar o cluster AKS e aplicações. Será implantada uma aplicação de exemplo que expõe métricas Prometheus, e um dashboard Grafana será importado para visualização.

## Pré-requisitos

*   Um cluster AKS provisionado com o add-on de monitoramento habilitado (conforme Lab 01).
*   Azure CLI instalado e configurado.
*   `kubectl` instalado e configurado para acessar o cluster AKS.

## Passos de Execução

### 1. Habilitar e Configurar Azure Managed Prometheus e Grafana

Execute o script `enable-managed-monitoring.sh` para garantir que o Managed Prometheus esteja habilitado no cluster AKS e para provisionar e configurar uma instância do Azure Managed Grafana.

```bash
cd ../../labs/02-managed-prometheus-grafana/scripts
bash enable-managed-monitoring.sh
```

**Saída Esperada:**

O script irá habilitar o Managed Prometheus (se já não estiver) e criar a instância do Azure Managed Grafana. Ao final, ele fornecerá o URL para acessar o Grafana.

```
Habilitando/Verificando o add-on de monitoramento no cluster AKS: aks-workshop-cluster...
... (saída da atualização do AKS)
Criando instância do Azure Managed Grafana: aksworkshopgrafanaXXXXXXXXXX...
... (saída da criação do Grafana)
Aguardando a criação da instância do Grafana...
Succeeded
Aguardando o provisionamento do Workspace do Azure Monitor...
ID do Workspace do Azure Monitor: /subscriptions/YOUR_SUBSCRIPTION_ID/resourceGroups/aks-workshop-rg/providers/Microsoft.Monitor/Accounts/DefaultAzureMonitorWorkspace-eastus
Conectando Azure Managed Grafana ao Azure Monitor Workspace...
... (saída da atualização do Grafana)
Azure Managed Prometheus e Grafana configurados com sucesso!
Para acessar o Grafana, execute: az grafana show --resource-group aks-workshop-rg --name aksworkshopgrafanaXXXXXXXXXX --query "properties.url" -o tsv
```

Anote o URL do Grafana.

### 2. Implantar Aplicação de Exemplo com Métricas Prometheus

Implante uma aplicação simples que expõe métricas no formato Prometheus. O Managed Prometheus irá automaticamente coletar essas métricas.

```bash
cd ../../labs/02-managed-prometheus-grafana/scripts
bash deploy-sample-app-metrics.sh
```

**Saída Esperada:**

```
Criando o namespace prometheus-app...
namespace/prometheus-app created
Implantando a aplicação de exemplo com métricas Prometheus no namespace prometheus-app...
deployment.apps/prometheus-app created
service/prometheus-app-service created
configmap/prometheus-config created
Aguardando a aplicação ser implantada...
deployment.apps/prometheus-app condition met
Aplicação de exemplo com métricas Prometheus implantada com sucesso!
```

Verifique se o pod da aplicação está rodando:

```bash
kubectl get pods -n prometheus-app
```

**Saída Esperada (exemplo):**

```
NAME                                READY   STATUS    RESTARTS   AGE
prometheus-app-xxxxxxxxxx-xxxxx   1/1     Running   0          2m
```

### 3. Acessar o Grafana e Importar Dashboard

1.  Abra o URL do Grafana obtido no passo 1 em seu navegador.
2.  Faça login (geralmente com sua conta Azure).
3.  No painel esquerdo, clique em **Dashboards** > **Import**.
4.  Clique em **Upload JSON file** e selecione o arquivo `grafana-nginx-ingress-dashboard.json` localizado em `aks-workshop/labs/02-managed-prometheus-grafana/manifests/`.
5.  Selecione a fonte de dados Prometheus (geralmente `Azure Monitor managed Prometheus`).
6.  Clique em **Import**.

Você deverá ver o dashboard do NGINX Ingress Controller populado com métricas, demonstrando a coleta de dados pelo Managed Prometheus e a visualização no Managed Grafana.

## Próximos Passos

Com o monitoramento configurado, você pode explorar a criação de seus próprios dashboards, alertas e aprofundar na análise das métricas do seu cluster AKS e aplicações. O próximo laboratório abordará o Service Mesh com Istio.
