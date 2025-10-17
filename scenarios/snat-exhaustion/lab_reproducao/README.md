# Lab de Reprodução – SNAT Exhaustion

Este laboratório força saturação de SNAT em um cluster AKS de laboratório para estudar sintomas e mitigação.

> **Pré-requisitos**
> - Cluster AKS com rede Azure CNI e Load Balancer padrão
> - Permissão para atualizar a subnet e outbound rules
> - Ferramentas: `az`, `kubectl`, `k6`

## Passos

1. **Limitar portas SNAT do Load Balancer para 256**
   ```bash
   az network lb outbound-rule update \
     --resource-group rg-aks-lab \
     --lb-name kubernetes \
     --name aksOutboundRule \
     --allocated-outbound-ports 256 \
     --idle-timeout 4
   ```

2. **Deploy do gerador de carga**
   ```bash
   kubectl apply -f lab_reproducao/snat-load-generator.yaml
   kubectl rollout status deployment/snat-load-generator -n labs
   ```

3. **Executar teste k6**
   ```bash
   kubectl exec -n labs deploy/snat-load-generator -- k6 run /scripts/pix-outbound.js
   ```

4. **Observar métricas**
   ```bash
   az monitor metrics list \
     --resource "/subscriptions/<sub>/resourceGroups/rg-aks-lab/providers/Microsoft.Network/loadBalancers/kubernetes" \
     --metric SNATPortUtilization --interval PT1M --top 5
   kubectl logs -n pagamentos deploy/pix-gateway | rg "connect: connection timed out"
   ```

5. **Mitigação** – associar NAT Gateway conforme `solucao.md` e repetir passo 3 para confirmar redução de timeouts.

6. **Limpeza**
   ```bash
   kubectl delete -f lab_reproducao/snat-load-generator.yaml
   az network lb outbound-rule update \
     --resource-group rg-aks-lab \
     --lb-name kubernetes \
     --name aksOutboundRule \
     --allocated-outbound-ports 1024
   ```

## Resultados Esperados
- Antes da mitigação: métrica `SNATPortUtilization` > 90% e logs de timeout.
- Após NAT Gateway: utilização < 30% e ausência de erros.
