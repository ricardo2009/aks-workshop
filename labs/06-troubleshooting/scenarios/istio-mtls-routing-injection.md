# Cenário de Troubleshooting: Falhas de mTLS, Roteamento ou Injeção do Istio

## Descrição do Problema

Aplicações em um service mesh Istio no AKS apresentam problemas de comunicação, como falhas de conexão, roteamento incorreto de tráfego ou pods que não recebem o sidecar do Istio (Envoy Proxy) durante a implantação.

## Causas Comuns

*   **Injeção de Sidecar Falha:** O sidecar do Istio não é injetado nos pods, geralmente devido a labels de namespace incorretas (`istio-injection=enabled`) ou a um webhook de admissão do Istio com problemas.
*   **Problemas de mTLS:** A comunicação mTLS (mutual TLS) entre serviços falha, resultando em erros de conexão. Isso pode ser devido a políticas de autenticação (`PeerAuthentication`) muito restritivas, certificados expirados ou problemas de sincronização do `istiod`.
*   **Roteamento Incorreto:** `VirtualService` ou `Gateway` configurados incorretamente, direcionando o tráfego para o serviço errado ou não expondo a aplicação externamente.
*   **Pods do Istio com Problemas:** Os pods do `istiod` (control plane) ou do `istio-ingressgateway` (data plane) estão em estado `CrashLoopBackOff`, `Pending` ou com erros nos logs.
*   **Conflitos de Network Policy:** Políticas de rede do Kubernetes podem estar bloqueando o tráfego que o Istio tenta gerenciar.

## Como Reproduzir o Problema (Exemplo)

1.  Implante uma aplicação em um namespace sem a label `istio-injection=enabled`.
2.  Configure um `PeerAuthentication` para `STRICT` mTLS, mas um dos serviços não está configurado para usar mTLS.
3.  Crie um `VirtualService` com um `host` ou `route` incorreto.

## Solução e Diagnóstico

1.  **Verificar a Injeção de Sidecar:**

    Verifique se o namespace da aplicação tem a label de injeção habilitada:

    ```bash
    kubectl get namespace <seu-namespace> -o yaml
    ```

    A saída deve incluir `istio-injection: enabled` nas labels. Se não estiver, adicione-a:

    ```bash
    kubectl label namespace <seu-namespace> istio-injection=enabled --overwrite
    ```

    Verifique se os pods da aplicação têm 2/2 contêineres (`READY`):

    ```bash
    kubectl get pods -n <seu-namespace>
    ```

2.  **Verificar o Status dos Pods do Istio:**

    ```bash
    kubectl get pods -n aks-istio-system
    ```

    Certifique-se de que `istiod` e `istio-ingressgateway` estão `Running` e `Ready`.

3.  **Verificar Logs do `istiod` e `istio-ingressgateway`:**

    ```bash
    kubectl logs -f -n aks-istio-system -l app=istiod
    kubectl logs -f -n aks-istio-system -l app=istio-ingressgateway
    ```

    Procure por erros ou avisos que possam indicar problemas de configuração ou comunicação.

4.  **Verificar Configurações do Istio (`Gateway`, `VirtualService`, `DestinationRule`, `PeerAuthentication`):**

    ```bash
    kubectl get gateway,virtualservice,destinationrule,peerauthentication -n <seu-namespace> -o yaml
    ```

    Inspecione as configurações para garantir que os hosts, portas, rotas e políticas de tráfego estejam corretos e correspondam ao que você espera.

5.  **Usar `istioctl analyze`:**

    A ferramenta `istioctl analyze` pode ajudar a identificar problemas de configuração no seu service mesh.

    ```bash
    istioctl analyze --namespace <seu-namespace>
    ```

6.  **Verificar o Status de mTLS:**

    Use `istioctl authn tls-check` para verificar o status de mTLS entre os serviços.

    ```bash
    istioctl authn tls-check <nome-do-pod>.<seu-namespace>
    ```

7.  **Testar Roteamento com `curl`:**

    A partir de um pod dentro do mesh, tente acessar outros serviços para verificar o roteamento interno. Para acesso externo, use o IP do `istio-ingressgateway`.

## Links Úteis

*   [Istio Troubleshooting](https://istio.io/latest/docs/ops/troubleshooting/)
*   [Istio-based service mesh add-on for Azure Kubernetes Service](https://learn.microsoft.com/en-us/azure/aks/istio-about)
*   [Diagnosing Istio with istioctl](https://istio.io/latest/docs/reference/commands/istioctl/#istioctl-analyze)

