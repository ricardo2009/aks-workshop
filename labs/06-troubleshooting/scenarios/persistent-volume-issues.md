# Cenário de Troubleshooting: Problemas com Volumes Persistentes

## Descrição do Problema

Pods que requerem armazenamento persistente não conseguem iniciar ou operar corretamente devido a problemas com `PersistentVolumeClaims` (PVCs), `PersistentVolumes` (PVs) ou `StorageClasses`. Isso pode se manifestar como pods presos no estado `Pending` ou `ContainerCreating` com erros relacionados a volumes, ou dados não sendo armazenados/recuperados como esperado.

## Causas Comuns

*   **PVC/PV não vinculado:** O `PersistentVolumeClaim` não consegue encontrar um `PersistentVolume` correspondente para se vincular, ou o PV não é provisionado corretamente.
*   **`StorageClass` Incorreta:** A `StorageClass` especificada no PVC não existe, está mal configurada ou não é compatível com o provisionador de armazenamento do Azure.
*   **Permissões de Acesso:** O pod não tem as permissões corretas para acessar o volume montado (e.g., permissões de arquivo/diretório dentro do volume).
*   **Problemas de Rede/Conectividade:** O nó do AKS não consegue se conectar ao armazenamento subjacente (Azure Disk, Azure Files).
*   **Capacidade Insuficiente:** O tamanho do volume solicitado no PVC é maior do que a capacidade disponível no `StorageClass` ou no Azure.
*   **Volume em Uso:** Tentativa de montar um volume que já está em uso exclusivo por outro pod (se o `accessMode` for `ReadWriteOnce`).

## Como Reproduzir o Problema (Exemplo)

1.  Crie um PVC que solicita uma `StorageClass` inexistente.
2.  Crie um PVC que solicita um tamanho de volume muito grande para o `StorageClass` padrão.
3.  Implante uma aplicação que tenta escrever em um volume sem as permissões adequadas.

## Solução e Diagnóstico

1.  **Verificar o Status do PVC:**

    ```bash
    kubectl get pvc -n <seu-namespace>
    ```

    Verifique se o PVC está no estado `Bound`. Se estiver `Pending`, algo está impedindo a vinculação.

2.  **Descrever o PVC:**

    ```bash
    kubectl describe pvc <nome-do-pvc> -n <seu-namespace>
    ```

    Procure por mensagens de erro na seção `Events` que expliquem por que o PVC não está sendo vinculado ou provisionado.

3.  **Verificar o Status do PV (se Bound):**

    Se o PVC estiver `Bound`, obtenha o nome do PV associado e descreva-o:

    ```bash
    kubectl describe pv <nome-do-pv>
    ```

    Verifique o `Status` e `Events` do PV para problemas no armazenamento subjacente.

4.  **Verificar a `StorageClass`:**

    ```bash
    kubectl get storageclass
    kubectl describe storageclass <nome-da-storageclass>
    ```

    Certifique-se de que a `StorageClass` referenciada pelo PVC existe e está configurada corretamente para o Azure (e.g., `kubernetes.io/azure-disk`, `kubernetes.io/azure-file`).

5.  **Verificar Logs do Pod:**

    Se o pod estiver em `Pending` ou `ContainerCreating` devido a problemas de volume, verifique os logs do pod (se disponível) e os eventos do pod.

    ```bash
    kubectl describe pod <nome-do-pod> -n <seu-namespace>
    kubectl logs <nome-do-pod> -n <seu-namespace>
    ```

    Procure por erros como `FailedMount`, `VolumeBindingFailed` ou `Permission denied`.

6.  **Verificar Permissões de Acesso ao Volume:**

    Se a aplicação estiver tendo problemas para ler/escrever no volume, pode ser um problema de permissões de arquivo/diretório. Considere usar um `initContainer` para definir permissões ou configurar o `securityContext` do pod.

7.  **Verificar o Portal do Azure:**

    No portal do Azure, verifique o status dos recursos de armazenamento (Azure Disks ou Azure Files) que estão sendo usados pelos PVs. Procure por alertas ou problemas de conectividade.

## Links Úteis

*   [Troubleshoot Azure Disk issues in Azure Kubernetes Service (AKS)](https://learn.microsoft.com/en-us/azure/aks/troubleshoot-azure-disk-issues)
*   [Troubleshoot Azure Files issues in Azure Kubernetes Service (AKS)](https://learn.microsoft.com/en-us/azure/aks/troubleshoot-azure-files-issues)
*   [Persistent Volumes in Kubernetes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)

