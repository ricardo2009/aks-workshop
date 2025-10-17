# Cenário de Troubleshooting: Pods em CrashLoopBackOff

## Descrição do Problema

Um ou mais pods no cluster AKS entram repetidamente no estado `CrashLoopBackOff`. Isso significa que o contêiner dentro do pod está iniciando, falhando, e o Kubernetes está tentando reiniciá-lo novamente após um atraso crescente.

## Causas Comuns

*   **Erro na Aplicação:** O código da aplicação dentro do contêiner tem um bug que causa uma falha imediata na inicialização ou durante a execução.
*   **Configuração Incorreta:** O manifesto do Deployment (ou outro recurso de workload) tem uma configuração incorreta, como um comando de inicialização (`command` ou `args`) errado, variáveis de ambiente ausentes ou incorretas, ou volumes mal configurados.
*   **Recursos Insuficientes:** O contêiner tenta alocar mais CPU ou memória do que o disponível no nó ou do que foi solicitado/limitado no manifesto do pod, levando a um `OOMKilled` (Out Of Memory Killed) ou CPU throttling.
*   **Imagem Docker Incorreta:** A imagem Docker especificada não existe, está corrompida, ou não contém o executável esperado.
*   **Dependências Ausentes:** A aplicação depende de um serviço externo (banco de dados, API) que não está acessível ou não está pronto no momento da inicialização do pod.
*   **Problemas de Permissão:** O contêiner não tem as permissões necessárias para acessar arquivos, diretórios ou recursos do sistema operacional.

## Como Reproduzir o Problema (Exemplo)

1.  Implante um contêiner que executa um comando inválido (e.g., `command: ["/bin/sh", "-c", "exit 1"]`).
2.  Implante uma aplicação que tenta se conectar a um banco de dados que não existe ou está inacessível.

## Solução e Diagnóstico

1.  **Verificar o Status do Pod:**

    ```bash
    kubectl get pods -n <seu-namespace>
    ```

    Observe o `STATUS` do pod. Se estiver `CrashLoopBackOff`, prossiga.

2.  **Verificar Logs do Contêiner:**

    Este é o passo mais importante. Os logs geralmente contêm a mensagem de erro que causou a falha.

    ```bash
    kubectl logs <nome-do-pod> -n <seu-namespace>
    ```

    Se o pod já reiniciou várias vezes, você pode querer ver os logs da instância anterior:

    ```bash
    kubectl logs <nome-do-pod> -n <seu-namespace> --previous
    ```

3.  **Descrever o Pod:**

    O comando `describe` fornece informações detalhadas sobre o pod, incluindo eventos, status dos contêineres, condições e mensagens de erro.

    ```bash
    kubectl describe pod <nome-do-pod> -n <seu-namespace>
    ```

    Preste atenção na seção `Events` e `State` dos contêineres.

4.  **Verificar o Manifesto do Deployment:**

    Inspecione o arquivo YAML do Deployment para garantir que o `command`, `args`, `env`, `image` e `volumeMounts` estejam corretos.

    ```bash
    kubectl get deployment <nome-do-deployment> -n <seu-namespace> -o yaml
    ```

5.  **Testar a Imagem Docker Localmente:**

    Se você tiver acesso à imagem Docker, tente executá-la localmente para ver se ela inicia sem erros.

    ```bash
    docker run <sua-imagem>
    ```

6.  **Verificar Recursos (CPU/Memória):**

    Se o `describe pod` indicar `OOMKilled` ou se os logs sugerirem falta de memória, ajuste os `resources.limits` e `resources.requests` no manifesto do pod.

7.  **Verificar Dependências Externas:**

    Certifique-se de que todos os serviços externos dos quais a aplicação depende estão acessíveis e funcionando.

## Links Úteis

*   [Troubleshoot applications in Azure Kubernetes Service (AKS)](https://learn.microsoft.com/en-us/azure/aks/troubleshooting-applications)
*   [Debugging Pods](https://kubernetes.io/docs/tasks/debug/debug-application/debug-running-pod/)
*   [Common Kubernetes Errors](https://www.bluematador.com/blog/kubernetes-errors)

