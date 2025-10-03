# Cenário de Troubleshooting: Falhas de DNS Interno

## Descrição do Problema

Uma aplicação implantada no cluster AKS não consegue resolver nomes de host de outros serviços dentro do mesmo cluster ou de serviços externos, resultando em erros de conexão ou `Name or service not known`.

## Causas Comuns

*   **`CoreDNS` não está saudável:** Os pods do CoreDNS podem estar em estado `CrashLoopBackOff` ou `Pending`.
*   **Configuração de `resolv.conf` incorreta:** Dentro dos pods, o arquivo `/etc/resolv.conf` pode não estar apontando para o serviço CoreDNS do cluster.
*   **`Network Policy` restritiva:** Uma política de rede pode estar bloqueando o tráfego DNS para os pods do CoreDNS.
*   **Problemas de conectividade de rede:** Problemas na rede subjacente do Azure podem afetar a comunicação DNS.

## Como Reproduzir o Problema (Exemplo)

1.  Implante uma aplicação que tenta resolver um nome de serviço inexistente ou um serviço externo bloqueado.
2.  Ou, simule uma falha no CoreDNS (não recomendado em ambiente de produção).

## Solução e Diagnóstico

1.  **Verificar o status dos pods do CoreDNS:**

    ```bash
    kubectl get pods -n kube-system -l k8s-app=kube-dns
    ```

    Verifique se todos os pods estão `Running` e `Ready`.

2.  **Verificar logs do CoreDNS:**

    ```bash
    kubectl logs -f -n kube-system -l k8s-app=kube-dns
    ```

    Procure por erros ou avisos que possam indicar problemas.

3.  **Testar resolução de DNS de dentro de um pod:**

    Crie um pod temporário para testes:

    ```bash
    kubectl run -it --rm --restart=Never busybox --image=busybox:1.28 -- nslookup kubernetes.default
    ```

    Tente resolver um serviço interno (`kubernetes.default`) e um externo (`google.com`). Se a resolução falhar, examine o `/etc/resolv.conf` dentro do pod:

    ```bash
    kubectl exec -it <nome-do-pod> -- cat /etc/resolv.conf
    ```

    O `nameserver` deve apontar para o IP do serviço `kube-dns` (geralmente `10.0.0.10` ou similar, dependendo da sua configuração de rede do AKS).

4.  **Verificar o serviço CoreDNS:**

    ```bash
    kubectl get svc -n kube-system -l k8s-app=kube-dns
    ```

    Confirme que o serviço está ativo e tem um `CLUSTER-IP`.

5.  **Verificar Network Policies (se aplicável):**

    Se você estiver usando Network Policies, verifique se há alguma regra que possa estar bloqueando o tráfego DNS para os pods ou do CoreDNS.

6.  **Reiniciar pods do CoreDNS (último recurso):**

    Se tudo mais falhar e os pods do CoreDNS estiverem com problemas, você pode tentar reiniciá-los (isso causará uma breve interrupção na resolução de DNS):

    ```bash
    kubectl delete pods -n kube-system -l k8s-app=kube-dns
    ```

## Links Úteis

*   [Troubleshoot DNS resolution in Azure Kubernetes Service (AKS)](https://learn.microsoft.com/en-us/azure/aks/troubleshooting-dns-resolution)
*   [CoreDNS documentation](https://coredns.io/)

