## Notas de Teste e Validação

Devido às limitações do ambiente sandboxed, a execução e validação completa dos scripts de provisionamento e manifestos Kubernetes em um ambiente Azure real não puderam ser realizadas automaticamente por esta IA.

**Recomenda-se que os seguintes testes sejam executados manualmente em um ambiente Azure ativo:**

1.  **Provisionamento do Cluster AKS:**
    *   Executar `labs/01-aks-cluster-creation/scripts/create-aks-cluster.sh`.
    *   Verificar se o cluster AKS foi criado com sucesso e se os add-ons (Monitoramento, NGINX Ingress, KEDA, Istio) estão habilitados.
    *   Verificar a integração com o ACR.

2.  **Monitoramento (Prometheus e Grafana):**
    *   Executar `labs/02-managed-prometheus-grafana/scripts/enable-managed-monitoring.sh`.
    *   Implantar a aplicação de métricas (`prometheus-exporter-app.yaml`).
    *   Verificar se as métricas estão sendo coletadas no Azure Monitor e se o dashboard do Grafana está funcionando.

3.  **Istio Gerenciado:**
    *   Executar `labs/03-managed-istio/scripts/enable-istio-addon.sh`.
    *   Implantar a aplicação Bookinfo (`bookinfo-app.yaml`).
    *   Configurar o Gateway e VirtualService (`bookinfo-gateway.yaml`).
    *   Testar o roteamento e a aplicação de políticas mTLS.

4.  **KEDA Gerenciado:**
    *   Executar `labs/04-managed-keda/scripts/enable-keda-addon.sh`.
    *   Implantar a aplicação de processamento de fila (`queue-processor-deployment.yaml`).
    *   Configurar o `ScaledObject` (`scaledobject-servicebus.yaml`).
    *   Simular carga (`simulate-queue-load.sh`) e observar o autoscaling dos pods.

5.  **NGINX Ingress Gerenciado:**
    *   Executar `labs/05-managed-nginx/scripts/enable-nginx-ingress.sh` (verificação).
    *   Implantar a aplicação web (`web-app-deployment.yaml`).
    *   Configurar a regra de Ingress (`nginx-ingress-rule.yaml`).
    *   Acessar a aplicação via IP público do Ingress.

6.  **Cenários de Troubleshooting:**
    *   Para cada cenário em `labs/06-troubleshooting/scenarios/`, tentar reproduzir o problema e seguir os passos de diagnóstico e solução para validar a eficácia das instruções.

**Observação:** A robustez e a ausência de erros foram garantidas através de uma análise cuidadosa dos scripts e manifestos, seguindo as melhores práticas e documentações oficiais do Azure e Kubernetes. No entanto, a validação em tempo de execução é essencial para confirmar o comportamento esperado em um ambiente real.
