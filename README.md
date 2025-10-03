# Workshop Técnico Hands-on de Azure Kubernetes Service (AKS)

Bem-vindo ao workshop técnico hands-on de Azure Kubernetes Service (AKS)! Este repositório contém o material completo para um workshop técnico de 2 dias, focado em robustez, troubleshooting e componentes avançados.

## Visão Geral dos Laboratórios

Os laboratórios são estruturados para serem executados sequencialmente, construindo conhecimento e complexidade a cada módulo. Cada laboratório inclui scripts, manifestos Kubernetes e um `README.md` detalhado com instruções passo a passo, saídas esperadas e dicas de troubleshooting.

### Módulos Disponíveis:

*   **[Lab 01: Criação e Configuração Básica do Cluster AKS](labs/01-aks-cluster-creation/README.md)**
    *   Aprenda a provisionar um cluster AKS com as extensões gerenciadas essenciais e integrar com o Azure Container Registry (ACR).

*   **[Lab 02: Monitoramento com Azure Managed Prometheus e Grafana](labs/02-managed-prometheus-grafana/README.md)**
    *   Habilite e configure o Azure Monitor Managed Service para Prometheus e Azure Managed Grafana para monitorar seu cluster e aplicações.

*   **[Lab 03: Service Mesh com Istio Gerenciado](labs/03-managed-istio/README.md)**
    *   Explore o Istio gerenciado no AKS, implantando uma aplicação de exemplo (Bookinfo) e configurando mTLS, roteamento e observabilidade.

*   **[Lab 04: Autoscaling com KEDA Gerenciado](labs/04-managed-keda/README.md)**
    *   Configure o KEDA para escalar automaticamente suas aplicações com base em eventos de filas do Azure Service Bus e métricas HTTP.

*   **[Lab 05: Ingress com NGINX Gerenciado](labs/05-managed-nginx/README.md)**
    *   Habilite o NGINX Ingress Controller gerenciado no AKS e configure o roteamento de tráfego para aplicações web.

*   **[Lab 06: Troubleshooting Avançado](labs/06-troubleshooting/README.md)**
    *   Aprenda a diagnosticar e resolver problemas comuns em clusters AKS, com cenários práticos e soluções detalhadas.

## Estrutura do Conteúdo

### Parte 1 – Fundamentos e Arquitetura do AKS

*   Visão macro do AKS: arquitetura, componentes principais, integração com o ecossistema Azure.
*   Modelos de rede (Kubenet vs Azure CNI), controle de acesso (RBAC, AAD), práticas recomendadas.
*   Boas práticas de design para clusters resilientes e seguros.
*   Exemplos visuais, analogias e diagramas para facilitar o entendimento.

### Parte 2 – Troubleshooting Avançado com Exemplos Práticos

Para cada cenário, serão fornecidos:

*   Descrição do problema
*   Sintomas observados
*   Ferramentas e comandos para diagnóstico (kubectl, logs, Azure Monitor, etc.)
*   Causas prováveis
*   Soluções detalhadas
*   Dicas de prevenção e otimização
*   Exemplo prático com YAMLs, comandos e outputs esperados

**Cenários a cobrir:**

*   Falhas de DNS interno
*   Problemas de conectividade com Azure CNI
*   Deploys com Helm falhando
*   AGIC com falhas de roteamento
*   KEDA não escalando
*   Istio com falhas de mTLS, roteamento ou injection
*   Pods em CrashLoopBackOff
*   Problemas com volumes persistentes
*   Falhas em upgrades de cluster

### Parte 3 – Tópicos Avançados e Otimizações

*   Escalabilidade com HPA, VPA, KEDA
*   Segurança: políticas de rede, PodSecurity, AAD, secrets
*   Observabilidade: Azure Monitor, Prometheus, Grafana, OpenTelemetry
*   Performance tuning: CPU/memória, afinidade, QoS
*   Custo e eficiência: spot nodes, node pools otimizados
*   Alta disponibilidade: zonas, probes, múltiplos node pools
*   Governança: Azure Policy, Defender for Kubernetes, audit logs

## Entregáveis

*   Slides em PowerPoint para cada módulo (pasta `slides/`)
*   Scripts e YAMLs dos labs hands-on (pasta `labs/`)
*   Guia de troubleshooting em PDF (pasta `troubleshooting_guide/`)
*   Templates de dashboards e alertas (pasta `dashboards_alerts/`)

## Como Usar

1.  **Clone o Repositório:**
    ```bash
    git clone https://github.com/ricardo2009/aks-workshop.git
    cd aks-workshop
    ```

2.  **Siga os Laboratórios:**
    Navegue até o diretório de cada laboratório (`labs/01-aks-cluster-creation`, `labs/02-managed-prometheus-grafana`, etc.) e siga as instruções detalhadas no arquivo `README.md` de cada um.

3.  **Pré-requisitos:**
    Certifique-se de ter o Azure CLI e `kubectl` instalados e configurados em sua máquina local. Uma assinatura Azure ativa é necessária para provisionar os recursos.

## Contribuições

Contribuições são bem-vindas! Sinta-se à vontade para abrir issues, sugerir melhorias ou enviar pull requests.

## Licença

Este projeto está licenciado sob a Licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

