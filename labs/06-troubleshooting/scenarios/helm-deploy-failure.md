# Cenário de Troubleshooting: Falhas em Deploys com Helm

## Descrição do Problema

Ao tentar implantar ou atualizar aplicações no AKS usando Helm, o comando falha com erros que podem variar desde problemas de conexão com o cluster até falhas na renderização de templates ou validação de recursos Kubernetes.

## Causas Comuns

*   **Conectividade com o Cluster:** O cliente Helm não consegue se comunicar com o servidor Kubernetes (API Server).
*   **Permissões Insuficientes:** A conta de serviço usada pelo Helm (ou o usuário que executa o Helm) não tem as permissões necessárias para criar ou modificar recursos no cluster.
*   **Erros de Sintaxe no Chart:** O chart Helm contém erros de sintaxe nos arquivos YAML ou nos templates Go.
*   **Valores Incorretos:** Valores passados para o chart via `--set` ou arquivo `values.yaml` são inválidos ou causam conflitos.
*   **Recursos Existentes:** Conflito com recursos Kubernetes que já existem no cluster e não são gerenciados pelo Helm (e.g., `helm install --atomic` falha se um recurso já existe).
*   **Versão do Helm/Kubernetes:** Incompatibilidade entre a versão do cliente Helm e a versão do cluster Kubernetes.
*   **Dependências do Chart:** Problemas ao resolver ou baixar dependências de outros charts.

## Como Reproduzir o Problema (Exemplo)

1.  Tente implantar um chart Helm com um `values.yaml` que contenha um erro de tipo (e.g., string onde se espera um número).
2.  Tente implantar um chart em um namespace onde o usuário não tem permissões de criação.

## Solução e Diagnóstico

1.  **Verificar Conectividade com o Cluster:**

    ```bash
    kubectl cluster-info
    kubectl get nodes
    ```

    Certifique-se de que o `kubectl` está configurado corretamente e pode se comunicar com o cluster.

2.  **Verificar Permissões:**

    Se você estiver usando uma conta de serviço, verifique as permissões do Role ou ClusterRole associado.

    ```bash
    kubectl auth can-i create deployment --namespace <seu-namespace>
    kubectl auth can-i get pods --all-namespaces
    ```

    Para depurar permissões de uma conta de serviço:

    ```bash
    kubectl auth can-i create deployment --as=system:serviceaccount:<namespace>:<service-account-name> --namespace <seu-namespace>
    ```

3.  **Depurar o Chart Helm:**

    Use os comandos `helm lint` e `helm template` para verificar o chart antes da implantação.

    ```bash
    helm lint <caminho-do-chart>
    helm template <nome-release> <caminho-do-chart> --values <seu-values.yaml>
    ```

    O `helm template` renderiza os manifestos finais, permitindo que você inspecione o YAML gerado em busca de erros.

4.  **Aumentar o Nível de Log do Helm:**

    Use a flag `--debug` e `--atomic` (para rollback automático em caso de falha) com o comando `helm install` ou `helm upgrade`.

    ```bash
    helm install <nome-release> <caminho-do-chart> --debug --atomic --values <seu-values.yaml>
    ```

    A saída detalhada pode fornecer pistas sobre a causa da falha.

5.  **Verificar Eventos do Kubernetes:**

    Após uma falha de implantação, verifique os eventos no namespace relevante para ver se há erros de validação ou agendamento de pods.

    ```bash
    kubectl get events -n <seu-namespace>
    ```

6.  **Verificar a Versão do Helm e Kubernetes:**

    ```bash
    helm version
    kubectl version
    ```

    Consulte a documentação do Helm para compatibilidade de versões.

## Links Úteis

*   [Helm Troubleshooting](https://helm.sh/docs/faq/#troubleshooting)
*   [Helm Best Practices](https://helm.sh/docs/chart_best_practices/)
*)
*   [Kubernetes RBAC](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)

