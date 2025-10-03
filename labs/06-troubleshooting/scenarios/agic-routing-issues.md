# Cenário de Troubleshooting: Problemas de Roteamento com AGIC (Application Gateway Ingress Controller)

## Descrição do Problema

O tráfego externo não está sendo roteado corretamente para as aplicações no AKS quando o Application Gateway Ingress Controller (AGIC) está em uso. Isso pode se manifestar como erros 502 Bad Gateway, 404 Not Found, ou a aplicação não sendo acessível pelo domínio configurado.

## Causas Comuns

*   **Configuração Incorreta do Ingress:** O recurso Ingress no Kubernetes não está configurado corretamente para o AGIC, ou o `ingressClassName` não está definido para `azure-application-gateway`.
*   **Backend Pools Incorretos:** O Application Gateway não está configurando os Backend Pools corretamente para apontar para os serviços do AKS.
*   **Probes de Saúde:** As probes de saúde configuradas no Application Gateway ou nos serviços do Kubernetes estão falhando, fazendo com que o Application Gateway remova os backends.
*   **Firewall do Application Gateway (WAF):** O WAF pode estar bloqueando requisições legítimas.
*   **Problemas de Conectividade de Rede:** NSGs ou UDRs bloqueando o tráfego entre o Application Gateway e os nós do AKS.
*   **Logs do AGIC:** O pod do AGIC pode estar com erros ou não conseguindo se comunicar com o Application Gateway ou o API Server do Kubernetes.

## Como Reproduzir o Problema (Exemplo)

1.  Implante uma aplicação e um Ingress para o AGIC, mas configure uma porta incorreta no serviço Kubernetes ou no Ingress.
2.  Configure uma probe de saúde que sempre falha para um serviço.

## Solução e Diagnóstico

1.  **Verificar o Status do Pod do AGIC:**

    ```bash
    kubectl get pods -n kube-system -l app=ingress-appgw
    ```

    Verifique se o pod do AGIC está `Running` e `Ready`.

2.  **Verificar Logs do AGIC:**

    ```bash
    kubectl logs -f -n kube-system -l app=ingress-appgw
    ```

    Procure por erros relacionados à sincronização com o Application Gateway ou à configuração de Ingress.

3.  **Inspecionar o Recurso Ingress:**

    ```bash
    kubectl get ingress <nome-do-ingress> -n <seu-namespace> -o yaml
    ```

    Verifique se o `ingressClassName` está correto (`azure-application-gateway`) e se as regras de roteamento (`rules`) e backends (`backend`) estão apontando para os serviços e portas corretas.

4.  **Verificar o Application Gateway no Portal do Azure:**

    *   **Backend Pools:** Verifique se os Backend Pools foram criados corretamente e se os IPs dos nós do AKS estão listados como backends.
    *   **HTTP Settings:** Verifique as portas e protocolos configurados.
    *   **Health Probes:** Verifique o status das probes de saúde. Se estiverem falhando, investigue os logs da aplicação no AKS.
    *   **Listeners e Rules:** Confirme que as regras de roteamento estão mapeando os listeners para os Backend Pools corretos.
    *   **WAF:** Se o WAF estiver habilitado, verifique os logs do WAF para ver se alguma requisição está sendo bloqueada.

5.  **Testar Conectividade entre AGIC e Pods:**

    A partir de um nó do AKS, tente acessar o IP e a porta do serviço que o AGIC deveria rotear. Isso pode ajudar a identificar problemas de rede subjacentes.

## Links Úteis

*   [Troubleshoot Application Gateway Ingress Controller (AGIC)](https://learn.microsoft.com/en-us/azure/application-gateway/ingress-controller-troubleshoot)
*   [Application Gateway Ingress Controller for Azure Kubernetes Service](https://learn.microsoft.com/en-us/azure/application-gateway/ingress-controller-overview)

