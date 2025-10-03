# Lab 06: Troubleshooting Avançado

## Objetivo

Este laboratório tem como objetivo apresentar cenários comuns de troubleshooting em clusters Azure Kubernetes Service (AKS) e guiar o aluno através de diagnósticos e soluções práticas. Cada cenário aborda um problema específico, suas causas comuns, como reproduzi-lo (se aplicável) e as etapas para diagnosticar e resolver.

## Pré-requisitos

*   Um cluster AKS em funcionamento.
*   Azure CLI instalado e configurado.
*   `kubectl` instalado e configurado para acessar o cluster AKS.
*   Conhecimento básico de Kubernetes e Azure.

## Cenários de Troubleshooting

Explore os seguintes cenários para aprimorar suas habilidades de diagnóstico e resolução de problemas no AKS:

### 1. [Falhas de DNS Interno](scenarios/dns-failure.md)

*   **Descrição:** Aplicações não conseguem resolver nomes de host de outros serviços ou externos.
*   **Foco:** Diagnóstico de problemas com CoreDNS, `resolv.conf` e políticas de rede.

### 2. [Problemas de Conectividade com Azure CNI](scenarios/azure-cni-connectivity.md)

*   **Descrição:** Pods não conseguem se comunicar entre si ou com recursos externos devido a problemas de rede.
*   **Foco:** Esgotamento de IPs, NSGs, tabelas de roteamento e logs de rede.

### 3. [Falhas em Deploys com Helm](scenarios/helm-deploy-failure.md)

*   **Descrição:** Erros ao implantar ou atualizar aplicações usando Helm.
*   **Foco:** Permissões, sintaxe de charts, valores incorretos e depuração de templates Helm.

### 4. [Problemas de Roteamento com AGIC (Application Gateway Ingress Controller)](scenarios/agic-routing-issues.md)

*   **Descrição:** Tráfego externo não chega às aplicações ou é roteado incorretamente quando AGIC está em uso.
*   **Foco:** Configuração do Ingress, Backend Pools do Application Gateway e logs do AGIC.

### 5. [KEDA não escalando](scenarios/keda-scaling-issues.md)

*   **Descrição:** Aplicações configuradas com KEDA não escalam ou escalam de forma inesperada.
*   **Foco:** Configuração de `ScaledObject`, triggers, acesso a fontes de eventos e logs do KEDA.

### 6. [Falhas de mTLS, Roteamento ou Injeção do Istio](scenarios/istio-mtls-routing-injection.md)

*   **Descrição:** Problemas com a comunicação segura (mTLS), roteamento de tráfego ou injeção de sidecar do Istio.
*   **Foco:** Políticas de autenticação, `VirtualService`, `DestinationRule` e logs do Istio.

### 7. [Pods em CrashLoopBackOff](scenarios/crashloopbackoff-pods.md)

*   **Descrição:** Pods que entram em um loop contínuo de inicialização e falha.
*   **Foco:** Logs de contêineres, eventos do pod, limites de recursos e configurações de imagem.

### 8. [Problemas com Volumes Persistentes](scenarios/persistent-volume-issues.md)

*   **Descrição:** Pods não conseguem montar volumes persistentes ou dados não são armazenados/recuperados corretamente.
*   **Foco:** `PersistentVolumeClaim`, `PersistentVolume`, `StorageClass` e logs de provisionamento de volume.

### 9. [Falhas em Upgrades de Cluster](scenarios/cluster-upgrade-failures.md)

*   **Descrição:** O processo de upgrade do cluster AKS falha ou resulta em um cluster instável.
*   **Foco:** Logs de operação do AKS, compatibilidade de versões e estratégias de upgrade.

## Como Utilizar os Cenários

Cada arquivo Markdown dentro da pasta `scenarios/` detalha um problema específico. Para cada cenário, você encontrará:

*   Uma **descrição** do problema.
*   **Causas comuns** que levam a esse problema.
*   Sugestões de **como reproduzir** o problema (para fins de aprendizado).
*   **Passos detalhados de diagnóstico e solução**, incluindo comandos `kubectl` e `az CLI` relevantes.
*   **Links úteis** para documentação oficial e recursos adicionais.

Recomenda-se ler o `README.md` de cada cenário e seguir os passos para simular e resolver os problemas, utilizando seu cluster AKS como ambiente de testes. Lembre-se de que a prática é fundamental para o domínio do troubleshooting em Kubernetes.
