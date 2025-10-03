# Workshop Técnico Hands-on de AKS

Este repositório contém o material completo para um workshop técnico hands-on de 2 dias sobre Azure Kubernetes Service (AKS), focado em robustez, troubleshooting e componentes avançados.

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

Clone este repositório para acessar todos os materiais do workshop.
