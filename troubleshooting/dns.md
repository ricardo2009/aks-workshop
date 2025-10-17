# Troubleshooting – Falhas de DNS Interno (CoreDNS)

## Objetivo
Orientar equipes da Caixa a diagnosticar e resolver problemas de resolução DNS dentro do AKS, garantindo baixa latência e alta disponibilidade do CoreDNS.

## Sintomas Comuns
- Latência elevada (>150ms) nas métricas `kubedns_dns_request_duration_seconds`.
- Mensagens de erro `SERVFAIL` ou `NXDOMAIN` em aplicações.
- Pods em CrashLoop devido a falha de resolução de endpoints internos.
- Logs do CoreDNS com mensagens `forwarding loop detected` ou `no upstream hosts available`.

## Diagnóstico Passo a Passo
1. **Verificar estado dos pods CoreDNS**
   ```bash
   kubectl get pods -n kube-system -l k8s-app=kube-dns -o wide
   kubectl describe pod -n kube-system <pod-coredns>
   ```
2. **Checar logs**
   ```bash
   kubectl logs -n kube-system deploy/coredns --tail 100
   ```
3. **Validar ConfigMap**
   ```bash
   kubectl get configmap coredns -n kube-system -o yaml
   ```
4. **Executar testes de resolução**
   ```bash
   kubectl run dns-debug --image=ghcr.io/ricardo2009/dns-tools:latest --restart=Never --command -- sleep 3600
   kubectl exec dns-debug -- dig api.pix.caixa.svc.cluster.local
   ```
5. **Monitorar métricas**
   - Azure Monitor: `kubedns_dns_request_duration_seconds` p95/p99.
   - Container Insights: logs `loop detected`, `denied request`.

## Linha Investigativa (kubectl + az)
| Ordem | Comando | Objetivo | Como interpretar |
|-------|---------|----------|------------------|
| 1 | `kubectl get pods -n kube-system -l k8s-app=kube-dns -o wide` | Garantir que todos os pods CoreDNS estejam `Running` e distribuídos em nós diferentes. | Se houver `Pending` ou nós repetidos, investigar afinidade ou falta de IP. |
| 2 | `kubectl get events -n kube-system --field-selector involvedObject.name=<pod>` | Identificar erros recentes de probe ou scheduling. | Eventos `FailedScheduling` indicam exaustão de IP; `Readiness probe failed` aponta para latência ou falha no processo. |
| 3 | `kubectl exec -n kube-system <pod-coredns> -- cat /etc/resolv.conf` | Validar encaminhamento configurado dentro do pod. | Valores fora do esperado (ex.: `nameserver 127.0.0.1`) indicam ConfigMap aplicado incorretamente. |
| 4 | `kubectl run dns-debug --image=ghcr.io/ricardo2009/dns-tools:latest --restart=Never --command -- sleep 3600` | Criar pod temporário para testes. | Deve subir em segundos; se falhar, verificar quotas ou PSP. |
| 5 | `kubectl exec dns-debug -- dig +trace api.pix.caixa.svc.cluster.local` | Testar resolução interna recursiva. | `SERVFAIL`/`connection timed out` confirmam problema; comparar com `dig @10.0.0.10` para validar upstream. |
| 6 | `az network watcher flow-log show --location brazilsouth --nsg <nsg-name>` | Confirmar se tráfego porta 53 está liberado. | Falta de fluxo ou negação indica bloqueio em NSG/Firewall. |
| 7 | `kubectl top pod -n kube-system --selector=k8s-app=kube-dns` | Avaliar consumo CPU/memória CoreDNS. | Uso próximo ao limite sugere necessidade de aumentar recursos ou réplicas. |

## Ferramentas
- `kubectl` (describe, logs, exec).
- `az aks nodepool show` para validar IPs disponíveis.
- `az network dns` (se integrando com DNS corporativo).
- Azure Monitor Workbooks (`dashboards_alerts/dns-latency.json`).

## Exemplos de Outputs
- Pod CoreDNS reiniciando:
  ```text
  Readiness probe failed: Get "http://10.0.0.10:8080/ready": context deadline exceeded
  ```
- Loop detectado:
  ```text
  plugin/loop: Forwarding loop detected in "forward": 10.20.0.10
  ```

## Causas Raiz Frequentes
- `stubDomains` apontando para IP inválido.
- Conditional forwarding para DNS corporativo indisponível.
- Exaustão de IPs Azure CNI derrubando pods CoreDNS.
- Restrições de firewall bloqueando porta 53/UDP.

## Playbook de Resolução
1. **Isolar mudança recente** via `kubectl rollout history`.
2. **Corrigir ConfigMap** utilizando `kubectl apply -f` (ex.: remover entrada duplicada).
3. **Reiniciar CoreDNS**: `kubectl rollout restart deployment/coredns -n kube-system`.
4. **Revalidar** com `dig` e monitorar métricas por 15 minutos.
5. **Documentar lições aprendidas** em `scenarios/<cenario>/`.

## Boas Práticas Preventivas
- Versionar ConfigMap CoreDNS em Git e usar `kubectl diff` antes de aplicar.
- Configurar alertas de latência DNS (>150ms) em Azure Monitor.
- Reduzir TTL dos registros críticos para facilitar failover.
- Implementar `podAntiAffinity` para distribuir pods CoreDNS entre zonas.

## Labs Relacionados
- `scenarios/dns-latency/lab_reproducao` – reproduz loop de forwarding.
- `labs/01-aks-cluster-creation` – validação de DNS pós-provisionamento.

## Referências
- [CoreDNS customization in AKS](https://learn.microsoft.com/azure/aks/coredns-custom)
- [Azure Monitor DNS metrics](https://learn.microsoft.com/azure/azure-monitor/insights/container-insights-analyze#dns)
