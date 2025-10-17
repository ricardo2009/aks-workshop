# Troubleshooting – Networking (Azure CNI)

## Objetivo
Resolver incidentes de conectividade no AKS relacionados à CNI Azure, incluindo exaustão de IPs, SNAT e políticas de rede.

## Sintomas Comuns
- Pods falhando com `FailedScheduling` por falta de IP.
- Aplicações sem acesso outbound (timeouts).
- Logs mostrando `no such host` ou `connection reset` em chamadas externas.
- Métricas `pod_allocated_ips / pod_capacity_ips > 0.8`.
- Regras de Network Policy bloqueando tráfego interno.

## Diagnóstico Passo a Passo
1. **Verificar capacidade de IPs**
   ```bash
   az aks show --resource-group rg-aks-caixa-prod --name aks-caixa-prod \
     --query "agentPoolProfiles[].{name:name,podCount:podCount,maxPods:maxPods,subnet:VnetSubnetID}" -o table
   kubectl get pod -o wide | wc -l
   ```
2. **Checar SNAT**
   - Avaliar métricas `UnderSNAT` no Azure Load Balancer/Application Gateway.
   - Se usar NAT Gateway, verificar `SNATPortUtilization`.
3. **Validar policies**
   ```bash
   kubectl get networkpolicy -A
   kubectl describe networkpolicy -n pagamentos deny-all-egress
   ```
4. **Testar conectividade** com `kubectl exec` e `curl` para hosts internos/externos.
5. **Revisar rotas**
   ```bash
   az network vnet subnet show --name aks-subnet --resource-group rg-network-caixa --vnet-name vnet-core
   ```

## Linha Investigativa (kubectl + rede)
| Ordem | Comando | Objetivo | Como interpretar |
|-------|---------|----------|------------------|
| 1 | `kubectl get nodes -o wide` | Validar sub-rede e IPs atribuídos aos nós. | `INTERNAL-IP` fora do range esperado sugere associação incorreta de subnet. |
| 2 | ``kubectl get pods -A -o wide | awk 'NR>1 {print $1,$2,$7}' | sort -u`` | Listar IPs de pod e detectar colisões. | IP repetido ou ausente indica exaustão/erro na CNI. |
| 3 | `kubectl describe pod <pod>` | Revisar eventos `FailedScheduling`/`FailedCreatePodSandBox`. | `Insufficient pods` ou `Failed to allocate IP` apontam para limites de subnet. |
| 4 | `kubectl exec -n <ns> <pod-debug> -- curl -I https://api.caixa.gov.br/healthz` | Teste outbound real. | Timeout confirma bloqueio; comparar com `--resolve` para DNS. |
| 5 | ``kubectl get networkpolicy -A -o yaml \| grep -n "deny"`` | Localizar policies restritivas. | Confirmar se namespace possui exceções necessárias. |
| 6 | `az monitor metrics list --resource <lb-resource-id> --metric SNATPortUtilization --interval PT5M` | Acompanhar saturação de portas SNAT em tempo quase real. | Valores > 0.75 sustentados indicam risco iminente (vide cenário `snat-exhaustion`). |
| 7 | `az network lb show --name <lb> --resource-group <rg> --query "frontendIpConfigurations[].privateIpAddress"` | Validar IPs SNAT/Load Balancer. | Apenas um IP público com tráfego alto pode causar exaustão. |
| 8 | `az network watcher connection-monitor test-configuration list --resource-group <rg> --name <monitor>` | Avaliar monitoramentos existentes. | Falhas recorrentes sinalizam caminho problemático específico. |
| 9 | `kubectl get cm -n kube-system azure-cni-networkmonitor -o yaml` | Checar configuração do monitor da CNI. | Ajustes incorretos podem desativar alertas. |

## Ferramentas
- `kubectl`, `az network`, Azure Monitor, Flow Logs.
- Script `scripts/validate/validate-networking.sh` para acompanhar capacidade e SNAT em tempo real.

## Exemplos de Outputs
- Evento de scheduling:
  ```text
  0/9 nodes are available: 9 Insufficient pods.
  ```
- Log NAT Gateway:
  ```text
  SNAT ports exhausted for IP 10.10.1.4
  ```

## Causas Raiz Frequentes
- Sub-rede subdimensionada (/27) para produção.
- Ausência de NAT Gateway em workloads com alto outbound.
- Network Policy `default deny` sem exceções necessárias.
- Azure Firewall bloqueando portas dinâmicas (>1024).

## Playbook de Resolução
1. Expandir sub-rede via `az network vnet subnet update --address-prefixes`.
2. Adicionar NAT Gateway e associar à sub-rede.
3. Ajustar Network Policies com regras específicas.
4. Revisar `maxPods` do node pool e recalibrar se necessário.
5. Monitorar após ajuste com `pod_allocated_ips` e Flow Logs.

> Consulte o cenário [`snat-exhaustion`](../scenarios/snat-exhaustion) para um exemplo real de mitigação com NAT Gateway.

## Boas Práticas Preventivas
- Planejar sub-redes /23 ou maiores.
- Utilizar `Azure CNI Overlay` quando IPs on-premises são escassos.
- Configurar alertas de utilização de IP > 70%.
- Documentar dependências de rede em `diagrams/topologia-rede.mmd`.

## Labs Relacionados
- `labs/01-aks-cluster-creation` (configuração inicial).
- `scenarios/dns-latency` (verificação de latência e forwarding).
- `scenarios/snat-exhaustion/lab_reproducao` (saturação controlada de SNAT e mitigação com NAT Gateway).

## Referências
- [Azure CNI best practices](https://learn.microsoft.com/azure/aks/azure-cni-overview)
- [Troubleshoot networking issues in AKS](https://learn.microsoft.com/azure/aks/troubleshoot-network)
