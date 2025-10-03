# Cenário de Troubleshooting: Comunicação Externa com AKS Privado

## Descrição do Problema

Em um cluster AKS privado, as aplicações ou o próprio cluster não conseguem se comunicar com serviços externos à VNet do AKS, ou com recursos do Azure que não estão configurados para Private Link. Isso pode incluir acesso a repositórios de imagens públicos, serviços de monitoramento externos, ou APIs de terceiros.

## Causas Comuns

*   **DNS Privado Incorreto:** O DNS privado para o endpoint da API do Kubernetes não está configurado corretamente, ou as zonas DNS privadas para serviços do Azure não estão vinculadas à VNet do AKS.
*   **Firewall do Azure/NVA:** Um Firewall do Azure ou Network Virtual Appliance (NVA) está bloqueando o tráfego de saída necessário do cluster AKS.
*   **Rotas Definidas pelo Usuário (UDRs):** UDRs configuradas incorretamente que direcionam o tráfego de saída para um NVA ou para a internet de forma inadequada.
*   **Network Security Groups (NSGs):** NSGs associados à subnet do AKS bloqueando o tráfego de saída para destinos externos.
*   **Private Link:** Serviços do Azure que deveriam ser acessados via Private Link não estão configurados com um Private Endpoint na VNet do AKS.
*   **IP Público de Saída:** O cluster AKS privado pode não ter um IP público de saída configurado ou o Load Balancer de saída está com problemas.

## Como Reproduzir o Problema (Exemplo)

1.  Tente puxar uma imagem de um repositório Docker público (e.g., Docker Hub) sem configurar o Firewall do Azure para permitir o tráfego de saída.
2.  Tente acessar uma API externa de um pod no cluster privado sem as regras de saída adequadas.

## Solução e Diagnóstico

1.  **Verificar a Configuração do DNS Privado:**

    *   Confirme que a zona DNS privada (`privatelink.eastus.azmk8s.io` ou similar) está vinculada à VNet do AKS.
    *   Verifique se o `kube-dns` ou `CoreDNS` no cluster está configurado para usar o DNS do Azure para resolução de nomes externos.

    ```bash
    # De dentro de um pod de teste no AKS
    kubectl run -it --rm --restart=Never busybox --image=busybox:1.28 -- nslookup google.com
    ```

2.  **Inspecionar o Firewall do Azure/NVA:**

    *   Verifique as regras do Firewall do Azure ou do NVA para garantir que o tráfego de saída para os destinos necessários (e.g., `*.docker.io`, `*.gcr.io`, IPs de APIs externas) está permitido.
    *   Consulte os logs do Firewall para identificar tráfego bloqueado.

3.  **Analisar Rotas Definidas pelo Usuário (UDRs):**

    *   Verifique as UDRs associadas à subnet do AKS. Certifique-se de que o tráfego de saída para a internet está sendo roteado corretamente, geralmente para o Firewall do Azure ou para um Load Balancer público.

    ```bash
    az network route-table route list --resource-group <RG_DA_VNET> --route-table-name <NOME_DA_ROUTE_TABLE> --output table
    ```

4.  **Verificar Network Security Groups (NSGs):**

    *   Inspecione as regras de saída dos NSGs associados à subnet do AKS para garantir que não há regras bloqueando o tráfego para destinos externos.

    ```bash
    az network nsg rule list --resource-group <RG_DO_NSG> --nsg-name <NOME_DO_NSG> --output table
    ```

5.  **Validar Configuração de Private Link:**

    *   Se você espera acessar serviços do Azure via Private Link, confirme que os Private Endpoints foram criados na VNet do AKS e que as zonas DNS privadas correspondentes estão configuradas e vinculadas.

6.  **Verificar IP Público de Saída (se aplicável):**

    *   Para clusters privados que precisam de acesso de saída à internet, verifique se um IP público de saída está configurado e associado ao Load Balancer de saída do cluster.

    ```bash
    az aks show --resource-group <RG_AKS> --name <AKS_CLUSTER_NAME> --query networkProfile.loadBalancerProfile.effectiveOutboundIpAddresses
    ```

7.  **Testar Conectividade de um Pod:**

    Implante um pod de teste com ferramentas como `curl`, `wget` ou `nslookup` para testar a conectividade com os serviços externos problemáticos.

    ```bash
    kubectl run -it --rm --restart=Never debug-pod --image=mcr.microsoft.com/aks/fundamental/base-ubuntu:v0.0.11 -- bash
    # Dentro do pod:
    curl -v <URL_DO_SERVICO_EXTERNO>
    ```

## Links Úteis

*   [Create a private Azure Kubernetes Service cluster](https://learn.microsoft.com/en-us/azure/aks/private-clusters)
*   [Troubleshoot outbound connections from an AKS cluster](https://learn.microsoft.com/en-us/troubleshoot/azure/azure-kubernetes/connectivity/basic-troubleshooting-outbound-connections)
*   [Azure Private Link for Azure Kubernetes Service](https://learn.microsoft.com/en-us/azure/aks/private-clusters-private-link)

