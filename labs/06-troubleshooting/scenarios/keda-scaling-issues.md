# Cenário de Troubleshooting: KEDA não escalando

## Descrição do Problema

Aplicações configuradas para autoscaling com KEDA (Kubernetes Event-driven Autoscaling) não escalam o número de réplicas de pods conforme o esperado, mesmo quando a carga de eventos aumenta. Isso pode resultar em filas de mensagens crescentes, latência elevada ou recursos subutilizados.

## Causas Comuns

*   **`ScaledObject` Incorreto:** Configuração errada no recurso `ScaledObject`, como `scaleTargetRef` apontando para um Deployment inexistente, `pollingInterval` muito alto, ou `minReplicas`/`maxReplicas` mal definidos.
*   **Trigger Mal Configurado:** O trigger definido no `ScaledObject` (e.g., Azure Service Bus, Kafka, Prometheus) não está configurado corretamente para se conectar à fonte de eventos ou os parâmetros de métrica estão incorretos.
*   **Acesso à Fonte de Eventos:** O KEDA não tem as permissões necessárias para acessar a fonte de eventos (e.g., string de conexão do Service Bus em um Secret incorreto, credenciais de Azure AD insuficientes).
*   **Pods do KEDA com Problemas:** Os pods do operador KEDA ou do metrics API server estão em estado `CrashLoopBackOff`, `Pending` ou com erros nos logs.
*   **Métricas Ausentes/Incorretas:** A fonte de métricas (e.g., Prometheus) não está coletando os dados que o KEDA espera, ou a query de métricas está retornando valores inesperados.
*   **Limites de Recursos do Cluster:** O cluster AKS não tem recursos (CPU, memória) suficientes para escalar mais pods, ou há limites de pods por nó/cluster.
*   **Versão do KEDA/Kubernetes:** Incompatibilidade entre a versão do KEDA e a versão do cluster Kubernetes.

## Como Reproduzir o Problema (Exemplo)

1.  Configure um `ScaledObject` com um `connectionFromEnv` apontando para uma variável de ambiente que não existe no Secret.
2.  Configure um trigger com um `queueName` incorreto para uma fila do Azure Service Bus.

## Solução e Diagnóstico

1.  **Verificar o Status do `ScaledObject`:**

    ```bash
    kubectl get scaledobject -n <seu-namespace>
    kubectl describe scaledobject <nome-do-scaledobject> -n <seu-namespace>
    ```

    Verifique a seção `Status` e `Conditions` para ver se há erros ou avisos. O `Ready` e `Active` devem ser `True` quando há eventos.

2.  **Verificar Logs do Operador KEDA:**

    ```bash
    kubectl get pods -n kube-system -l app.kubernetes.io/name=keda-operator
    kubectl logs -f <nome-do-pod-keda-operator> -n kube-system
    ```

    Procure por mensagens de erro relacionadas ao `ScaledObject` ou à conexão com a fonte de eventos.

3.  **Verificar o Secret da Conexão (se aplicável):**

    Se o trigger usar um Secret para credenciais (como o Azure Service Bus), verifique se o Secret existe e se a chave está correta.

    ```bash
    kubectl get secret <nome-do-secret> -n <seu-namespace> -o yaml
    ```

    Decodifique o valor da `connectionString` (base64) para garantir que está correto.

4.  **Testar a Conectividade com a Fonte de Eventos:**

    Se possível, tente se conectar à fonte de eventos (e.g., Azure Service Bus, Kafka) de fora do cluster ou de um pod de teste para verificar a conectividade e as credenciais.

5.  **Verificar Métricas (se aplicável):**

    Se o trigger for baseado em métricas (e.g., Prometheus), verifique se as métricas estão sendo coletadas corretamente e se a query do KEDA está retornando os valores esperados.

6.  **Verificar Eventos do Kubernetes:**

    ```bash
    kubectl get events -n <seu-namespace>
    ```

    Procure por eventos relacionados ao `HorizontalPodAutoscaler` (HPA) que o KEDA cria, ou eventos de falha de agendamento de pods.

7.  **Verificar Limites de Recursos do Cluster:**

    Confirme se o cluster tem capacidade para escalar mais pods. Verifique o uso de CPU/memória dos nós e os limites de pods por nó/cluster.

## Links Úteis

*   [KEDA Troubleshooting Guide](https://keda.sh/docs/latest/troubleshooting/)
*   [KEDA ScaledObject Specification](https://keda.sh/docs/latest/concepts/scaled-object/)
*   [Azure Service Bus Scaler for KEDA](https://keda.sh/docs/latest/scalers/azure-service-bus/)

