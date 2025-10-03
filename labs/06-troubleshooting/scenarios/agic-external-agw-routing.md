# Cenário de Troubleshooting: AGIC com Application Gateway Externo

## Descrição do Problema

Ao utilizar o Application Gateway Ingress Controller (AGIC) com um Application Gateway pré-existente e externo ao ciclo de vida do AKS, as aplicações não são acessíveis, o roteamento falha, ou o AGIC não consegue sincronizar as configurações com o Application Gateway. Isso pode resultar em erros 502 Bad Gateway, 404 Not Found, ou o Application Gateway não refletindo as regras de Ingress do Kubernetes.

## Causas Comuns

*   **Permissões Insuficientes:** A identidade gerenciada (Managed Identity) configurada para o AGIC não possui as permissões necessárias para gerenciar o Application Gateway (e.g., `Contributor` ou `Application Gateway Contributor` no Application Gateway e no grupo de recursos).
*   **Configuração Incorreta do AGIC:** O AGIC não está configurado para apontar para o Application Gateway correto, ou o `resourceId` no `helm values` (ou no add-on) está incorreto.
*   **Conflito de Propriedade:** O AGIC tenta assumir controle total de um Application Gateway que já possui configurações manuais ou é gerenciado por outras ferramentas, resultando em sobrescrita indesejada ou falhas de sincronização.
*   **Problemas de Rede:** NSGs, UDRs ou Firewalls do Azure bloqueando a comunicação entre o AGIC (rodando no AKS) e o Application Gateway.
*   **Probes de Saúde:** As probes de saúde configuradas no Application Gateway não conseguem alcançar os pods do AKS, fazendo com que os backends sejam marcados como não saudáveis.
*   **Versão do AGIC/Kubernetes:** Incompatibilidade entre a versão do AGIC e a versão do Kubernetes ou do Application Gateway.

## Como Reproduzir o Problema (Exemplo)

1.  Configure o AGIC para usar um Application Gateway existente, mas omita as permissões necessárias para a identidade gerenciada do AGIC.
2.  Implante um Ingress com um `host` que não está configurado no DNS para apontar para o IP público do Application Gateway.

## Solução e Diagnóstico

1.  **Verificar Logs do Pod do AGIC:**

    ```bash
    kubectl get pods -n kube-system -l app=ingress-appgw
    kubectl logs -f <nome-do-pod-agic> -n kube-system
    ```

    Procure por erros relacionados a permissões (`AuthorizationFailed`), conexão com o Application Gateway, ou falhas na sincronização de recursos.

2.  **Verificar Permissões da Identidade Gerenciada do AGIC:**

    *   Identifique a identidade gerenciada usada pelo AGIC (geralmente configurada durante a instalação via Helm ou add-on).
    *   No Portal do Azure, navegue até o Application Gateway e seu grupo de recursos. Verifique se a identidade gerenciada do AGIC possui as permissões de `Contributor` ou `Application Gateway Contributor`.

    ```bash
    # Exemplo para verificar atribuições de função para uma identidade gerenciada
    # Substitua <RESOURCE_GROUP_NAME> e <MANAGED_IDENTITY_PRINCIPAL_ID>
    az role assignment list --assignee <MANAGED_IDENTITY_PRINCIPAL_ID> --scope /subscriptions/<SUBSCRIPTION_ID>/resourceGroups/<RESOURCE_GROUP_NAME>/providers/Microsoft.Network/applicationGateways/<APPLICATION_GATEWAY_NAME>
    ```

3.  **Inspecionar a Configuração do AGIC:**

    Se o AGIC foi instalado via Helm, verifique os `values.yaml` usados. Se foi via add-on, verifique a configuração do add-on no cluster AKS.

    ```bash
    # Para add-on
    az aks show --resource-group <RG_AKS> --name <AKS_CLUSTER_NAME> --query addonProfiles.ingressApplicationGateway.config
    ```

    Confirme que o `applicationGatewayId` (ou `resourceId`) está apontando para o Application Gateway correto.

4.  **Verificar o Application Gateway no Portal do Azure:**

    *   **Backend Pools:** Verifique se os Backend Pools foram criados/atualizados pelo AGIC e se os IPs dos nós do AKS estão listados como backends.
    *   **HTTP Settings:** Verifique as portas e protocolos configurados.
    *   **Health Probes:** Verifique o status das probes de saúde. Se estiverem falhando, investigue os logs da aplicação no AKS e as regras de NSG/Firewall.
    *   **Listeners e Rules:** Confirme que as regras de roteamento estão mapeando os listeners para os Backend Pools corretos.
    *   **WAF:** Se o WAF estiver habilitado, verifique os logs do WAF para ver se alguma requisição está sendo bloqueada.

5.  **Verificar Conflitos de Propriedade:**

    Se o Application Gateway for compartilhado, certifique-se de que o AGIC está configurado para operar em modo de coexistência (se suportado pela versão) ou que as regras gerenciadas pelo AGIC não estão sendo sobrescritas por outras fontes.

6.  **Testar Conectividade de Rede:**

    A partir de um nó do AKS, tente acessar o IP privado do Application Gateway (se estiver na mesma VNet) para verificar a conectividade de rede.

## Links Úteis

*   [Troubleshoot Application Gateway Ingress Controller (AGIC)](https://learn.microsoft.com/en-us/azure/application-gateway/ingress-controller-troubleshoot)
*   [Install AGIC by using an existing Application Gateway](https://learn.microsoft.com/en-us/azure/application-gateway/ingress-controller-install-existing)
*   [Troubleshoot Application Gateway Ingress Controller connectivity issues](https://learn.microsoft.com/en-us/troubleshoot/azure/azure-kubernetes/load-bal-ingress-c/troubleshoot-app-gateway-ingress-controller-connectivity-issues)

