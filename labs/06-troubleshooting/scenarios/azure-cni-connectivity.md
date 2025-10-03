# Cenário de Troubleshooting: Problemas de Conectividade com Azure CNI

## Descrição do Problema

Pods em um cluster AKS não conseguem se comunicar entre si, com serviços externos ou com recursos do Azure, mesmo que o DNS esteja funcionando corretamente. Isso geralmente se manifesta como pods em estado `ContainerCreating` ou `CrashLoopBackOff` devido a falhas de rede, ou aplicações que não conseguem acessar bancos de dados ou APIs externas.

## Causas Comuns

*   **Esgotamento de IPs:** O pool de IPs configurado para o Azure CNI pode ter se esgotado, impedindo que novos pods obtenham endereços IP.
*   **Problemas de Roteamento:** Tabelas de roteamento incorretas ou Network Security Groups (NSGs) bloqueando o tráfego necessário.
*   **Configuração de VNet/Subnet:** Configurações incorretas na VNet ou subnet onde o AKS está implantado.
*   **Versão do CNI:** Problemas de compatibilidade ou bugs em versões específicas do Azure CNI.
*   **Firewall do Azure:** Se um Firewall do Azure estiver em uso, ele pode estar bloqueando o tráfego de saída necessário.

## Como Reproduzir o Problema (Exemplo)

1.  Implante um grande número de pods em um cluster com um pool de IPs limitado.
2.  Configure um NSG para bloquear o tráfego de saída para a internet a partir dos nós do AKS.

## Solução e Diagnóstico

1.  **Verificar logs de eventos do Kubernetes:**

    ```bash
    kubectl get events --sort-by=".metadata.creationTimestamp"
    ```

    Procure por eventos relacionados a falhas de agendamento de pods ou erros de rede.

2.  **Verificar logs do `kubelet` e `containerd` nos nós:**

    Acesse os nós do AKS via SSH (se permitido) e verifique os logs do `kubelet` e do `containerd` para erros de rede.

    ```bash
    # Exemplo para um nó Linux
    ssh <user>@<node-ip>
    sudo journalctl -u kubelet -f
    sudo journalctl -u containerd -f
    ```

3.  **Verificar o uso de IPs na subnet:**

    No portal do Azure ou via Azure CLI, verifique a utilização da subnet do AKS. Se estiver próxima de 100%, o esgotamento de IPs é provável.

    ```bash
    az network vnet subnet show --resource-group <RG_DA_VNET> --vnet-name <NOME_DA_VNET> --name <NOME_DA_SUBNET> --query ipConfigurations.length
    ```

4.  **Verificar NSGs e Tabelas de Roteamento:**

    Analise os NSGs associados à subnet do AKS para garantir que o tráfego necessário (e.g., porta 443 para o Azure API Server, tráfego de saída para a internet) não esteja bloqueado. Verifique também as tabelas de roteamento personalizadas, se existirem.

    ```bash
    az network nsg rule list --resource-group <RG_DO_NSG> --nsg-name <NOME_DO_NSG> --output table
    ```

5.  **Testar conectividade de dentro de um pod:**

    Use um pod de teste para verificar a conectividade com outros serviços ou IPs externos.

    ```bash
    kubectl run -it --rm --restart=Never debug-pod --image=mcr.microsoft.com/aks/fundamental/base-ubuntu:v0.0.11 -- bash
    # Dentro do pod:
    ping <IP_DE_OUTRO_POD>
    curl google.com
    ```

6.  **Verificar o status do CNI:**

    Em alguns casos, pode ser necessário verificar o status dos componentes do CNI nos nós.

    ```bash
    # Exemplo de comando para verificar o status do CNI em um nó (pode variar)
    sudo ip a
    sudo ip route
    ```

## Links Úteis

*   [Troubleshoot Azure CNI network issues in Azure Kubernetes Service (AKS)](https://learn.microsoft.com/en-us/azure/aks/troubleshooting-azure-cni)
*   [Azure Kubernetes Service (AKS) networking concepts](https://learn.microsoft.com/en-us/azure/aks/concepts-network)

