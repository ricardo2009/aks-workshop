# Guia de Troubleshooting Avançado para AKS

Este guia compila os cenários de troubleshooting mais comuns e suas soluções para clusters Azure Kubernetes Service (AKS). Ele serve como um recurso rápido para diagnosticar e resolver problemas, complementando os laboratórios hands-on do workshop.

## Cenários Abordados:

*   [Falhas de DNS Interno](scenarios/dns-failure.md)
*   [Problemas de Conectividade com Azure CNI](scenarios/azure-cni-connectivity.md)
*   [Falhas em Deploys com Helm](scenarios/helm-deploy-failure.md)
*   [Problemas de Roteamento com AGIC (Application Gateway Ingress Controller)](scenarios/agic-routing-issues.md)
*   [KEDA não escalando](scenarios/keda-scaling-issues.md)
*   [Falhas de mTLS, Roteamento ou Injeção do Istio](scenarios/istio-mtls-routing-injection.md)
*   [Pods em CrashLoopBackOff](scenarios/crashloopbackoff-pods.md)
*   [Problemas com Volumes Persistentes](scenarios/persistent-volume-issues.md)
*   [Falhas em Upgrades de Cluster](scenarios/cluster-upgrade-failures.md)

## Como Usar Este Guia

Cada cenário é um documento Markdown separado que detalha o problema, suas causas, como reproduzi-lo (para fins de aprendizado), e os passos para diagnóstico e solução. Recomenda-se a leitura atenta de cada cenário e a aplicação das técnicas de diagnóstico em um ambiente de testes.

## Ferramentas Essenciais

Para o troubleshooting eficaz, as seguintes ferramentas são indispensáveis:

*   **Azure CLI:** Para gerenciar recursos do Azure e obter informações do cluster AKS.
*   **`kubectl`:** Para interagir com o cluster Kubernetes, inspecionar pods, serviços, logs e eventos.
*   **`istioctl` (para Istio):** Ferramenta de linha de comando para gerenciar e diagnosticar o Istio.
*   **Portal do Azure:** Para verificar o status de recursos do Azure, logs de atividade e configurações de rede.
*   **Azure Monitor / Log Analytics:** Para coletar e analisar logs e métricas do cluster e aplicações.

## Dicas Gerais de Troubleshooting

*   **Comece pelos logs:** Sempre verifique os logs dos pods e dos componentes do sistema.
*   **Descreva os recursos:** Use `kubectl describe` para obter informações detalhadas sobre pods, deployments, serviços, etc.
*   **Verifique eventos:** `kubectl get events` pode revelar problemas de agendamento ou inicialização.
*   **Teste a conectividade:** Use pods temporários (`kubectl run -it --rm busybox --image=busybox -- sh`) para testar a conectividade de rede e a resolução de DNS de dentro do cluster.
*   **Isolamento:** Tente isolar o problema, removendo componentes ou simplificando a configuração para identificar a causa raiz.

Este guia será atualizado periodicamente com novos cenários e melhores práticas. Contribuições são bem-vindas!
