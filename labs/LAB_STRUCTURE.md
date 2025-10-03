# Estrutura dos Laboratórios Hands-on de AKS

Este documento detalha a estrutura e o conteúdo de cada laboratório hands-on do workshop de AKS, com foco em modularidade, facilidade de execução e visualização de resultados.

## Visão Geral dos Módulos

Cada módulo de laboratório será composto por:

*   **`scripts/`**: Contém scripts Bash ou Azure CLI para provisionamento, configuração e execução de testes.
*   **`manifests/`**: Contém arquivos YAML para implantação de recursos Kubernetes (Deployments, Services, Ingresses, ScaledObjects, etc.).
*   **`README.md`**: Um guia detalhado para o laboratório, incluindo objetivos, pré-requisitos, passos de execução, comandos esperados e como verificar os resultados (incluindo logs e dashboards).

## Módulos de Laboratório

### 01 - Criação e Configuração Básica do Cluster AKS

**Objetivo:** Provisionar um cluster AKS com configurações básicas e integrar com o Azure Container Registry (ACR).

*   **`scripts/`**
    *   `create-aks-cluster.sh`: Script para criar o grupo de recursos, o ACR e o cluster AKS com as extensões necessárias (Istio, KEDA, NGINX Ingress Controller).
    *   `configure-kubectl.sh`: Script para configurar o `kubectl` para acessar o cluster.
*   **`manifests/`**
    *   `sample-app.yaml`: Aplicação de exemplo simples para testar a conectividade básica.
*   **`README.md`**: Guia passo a passo para criar o cluster e implantar a aplicação de teste.

### 02 - Monitoramento com Azure Managed Prometheus e Grafana

**Objetivo:** Habilitar e configurar o Azure Monitor Managed Service para Prometheus e Azure Managed Grafana para monitorar o cluster AKS e aplicações.

*   **`scripts/`**
    *   `enable-managed-monitoring.sh`: Script para habilitar o Managed Prometheus e Grafana no cluster AKS.
    *   `deploy-sample-app-metrics.sh`: Script para implantar uma aplicação de exemplo que expõe métricas Prometheus.
*   **`manifests/`**
    *   `prometheus-exporter-app.yaml`: Aplicação de exemplo com endpoint `/metrics`.
    *   `grafana-dashboard-config.json`: Exemplo de configuração de dashboard Grafana (importável).
*   **`README.md`**: Guia para configurar o monitoramento, implantar a aplicação com métricas e visualizar no Grafana.

### 03 - Service Mesh com Istio Gerenciado

**Objetivo:** Habilitar o add-on Istio gerenciado no AKS e configurar um serviço de exemplo com mTLS, roteamento e observabilidade.

*   **`scripts/`**
    *   `enable-istio-addon.sh`: Script para habilitar o add-on Istio no cluster AKS.
    *   `deploy-bookinfo-app.sh`: Script para implantar a aplicação Bookinfo (exemplo padrão do Istio).
    *   `configure-istio-gateway.sh`: Script para configurar um Gateway e VirtualService para a aplicação.
*   **`manifests/`**
    *   `bookinfo-deployment.yaml`: Manifestos da aplicação Bookinfo.
    *   `bookinfo-gateway.yaml`: Configuração do Gateway e VirtualService do Istio.
    *   `destination-rules.yaml`: Regras de destino para mTLS e balanceamento de carga.
*   **`README.md`**: Guia para implantar o Istio, a aplicação Bookinfo e configurar o tráfego.

### 04 - Autoscaling com KEDA Gerenciado

**Objetivo:** Habilitar o add-on KEDA gerenciado no AKS e configurar o autoscaling baseado em filas de mensagens (Azure Service Bus) e métricas HTTP.

*   **`scripts/`**
    *   `enable-keda-addon.sh`: Script para habilitar o add-on KEDA no cluster AKS.
    *   `deploy-queue-processor.sh`: Script para implantar uma aplicação que processa mensagens de uma fila.
    *   `simulate-queue-load.sh`: Script para enviar mensagens para a fila e observar o autoscaling.
*   **`manifests/`**
    *   `queue-processor-deployment.yaml`: Deployment da aplicação processadora de fila.
    *   `scaledobject-servicebus.yaml`: ScaledObject para autoscaling baseado em Azure Service Bus.
    *   `http-scaledobject.yaml`: Exemplo de ScaledObject para autoscaling baseado em HTTP (com NGINX Ingress).
*   **`README.md`**: Guia para configurar o KEDA, implantar a aplicação e testar o autoscaling.

### 05 - Ingress com NGINX Gerenciado

**Objetivo:** Habilitar o NGINX Ingress Controller gerenciado no AKS e configurar o roteamento de tráfego para aplicações.

*   **`scripts/`**
    *   `enable-nginx-ingress.sh`: Script para habilitar o NGINX Ingress Controller no cluster AKS.
    *   `deploy-web-app.sh`: Script para implantar uma aplicação web de exemplo.
    *   `configure-ingress-rule.sh`: Script para configurar uma regra de Ingress para a aplicação.
*   **`manifests/`**
    *   `web-app-deployment.yaml`: Deployment e Service da aplicação web.
    *   `nginx-ingress-rule.yaml`: Recurso Ingress para roteamento de tráfego.
*   **`README.md`**: Guia para configurar o NGINX Ingress, implantar a aplicação e testar o acesso externo.

### 06 - Troubleshooting Avançado

**Objetivo:** Apresentar cenários comuns de troubleshooting e suas soluções, com exemplos práticos.

*   **`scenarios/`**
    *   `dns-failure.md`: Descrição e solução para falhas de DNS interno.
    *   `azure-cni-connectivity.md`: Descrição e solução para problemas de conectividade com Azure CNI.
    *   `helm-deploy-failure.md`: Descrição e solução para falhas em deploys com Helm.
    *   `agic-routing-issues.md`: Descrição e solução para problemas de roteamento com AGIC.
    *   `keda-scaling-issues.md`: Descrição e solução para KEDA não escalando.
    *   `istio-mtls-routing-injection.md`: Descrição e solução para falhas de mTLS, roteamento ou injection do Istio.
    *   `crashloopbackoff-pods.md`: Descrição e solução para Pods em CrashLoopBackOff.
    *   `persistent-volume-issues.md`: Descrição e solução para problemas com volumes persistentes.
    *   `cluster-upgrade-failures.md`: Descrição e solução para falhas em upgrades de cluster.
*   **`README.md`**: Visão geral dos cenários de troubleshooting e como reproduzi-los/solucioná-los.

Cada `README.md` de laboratório incluirá seções para comandos, saídas esperadas e links para a documentação oficial para aprofundamento. A ideia é que o aluno possa copiar e colar os comandos e observar os resultados, como em um notebook interativo.
