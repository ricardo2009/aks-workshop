# Troubleshooting – Istio (Service Mesh)

## Objetivo
Diagnosticar problemas comuns de tráfego e segurança ao utilizar Istio em clusters AKS, especialmente com mTLS e roteamento avançado.

## Sintomas Comuns
- Erros HTTP 503 com mensagem `UH` (upstream connection failure).
- Tráfego bloqueado após habilitar mTLS.
- Dashboards Kiali/Grafana sem dados.
- Sidecar `istio-proxy` em CrashLoop.

## Diagnóstico Passo a Passo
1. **Validar injeção de sidecar**
   ```bash
   kubectl get pod -n pagamentos --show-labels | grep istio-injection
   ```
2. **Checar políticas mTLS**
   ```bash
   kubectl get peerauthentication -A
   kubectl describe peerauthentication default -n pagamentos
   ```
3. **Inspecionar DestinationRules/VirtualServices**
   ```bash
   kubectl get virtualservice -A
   kubectl describe virtualservice pix-api -n pagamentos
   ```
4. **Analisar logs do Envoy**
   ```bash
   kubectl logs <pod> -n pagamentos -c istio-proxy --tail 50
   ```
5. **Ver métricas** (Prometheus Istio / Azure Monitor)
   - `istio_requests_total`, `istio_tcp_connections_closed_total`.

## Linha Investigativa (kubectl + istioctl)
| Ordem | Comando | Objetivo | Como interpretar |
|-------|---------|----------|------------------|
| 1 | `kubectl get namespace pagamentos -o jsonpath='{.metadata.labels.istio-injection}'` | Verificar se a injeção automática está habilitada. | Valor `enabled` garante sidecars novos; `null` exige `kubectl label`. |
| 2 | `kubectl get pod -n <namespace> -l app=<app> -o jsonpath='{.items[*].spec.containers[*].name}'` | Confirmar presença do container `istio-proxy`. | Ausência indica falha de mutating webhook. |
| 3 | `istioctl proxy-status` | Avaliar sincronismo dos proxies. | Status `STALE`/`NOT SENT` aponta config ausente no control plane. |
| 4 | `istioctl proxy-config routes <pod>.<namespace>` | Inspecionar rotas aplicadas ao Envoy. | Rota faltante ou host errado confirma erro em VirtualService. |
| 5 | `kubectl get peerauthentication -A -o yaml` | Revisar políticas mTLS herdadas. | `mode: STRICT` sem DestinationRule correspondente gera 503. |
| 6 | `kubectl logs <pod> -c istio-proxy --tail 100` | Observar erros TLS/rota. | Mensagens `tls.handshake` ou `no healthy upstream` direcionam ajuste. |
| 7 | `kubectl exec <pod> -c istio-proxy -- curl -I http://<service>:<port>/healthz` | Validar rota interna com sidecar. | Sucesso 200 confirma caminho; erro 503 implica roteamento. |
| 8 | `istioctl analyze -n <namespace>` | Rodar lint estático nas configs. | Saídas com `Error [IST0101]` sinalizam conflito de hosts/dominios. |

## Ferramentas
- `istioctl proxy-status`, `istioctl analyze`.
- Kiali, Grafana, Jaeger.

## Exemplos de Outputs
- `istioctl proxy-status`:
  ```text
  NAME                                                   CDS        LDS        EDS        RDS        ECDS       STATUS
  payments/pix-api-57dd...                               SYNCED     SYNCED     SYNCED     SYNCED     NOT SENT   STALE
  ```
- Log mTLS falho:
  ```text
  upstream connect error or disconnect/reset before headers. reset reason: connection termination
  ```

## Causas Raiz Frequentes
- DestinationRule sem `tls` compatível com PeerAuthentication.
- Falta de `Sidecar` resource limitando hosts permitidos.
- Certificados expirados (quando utilizando CA externa).
- Configuração errada de gateways (porta/cipher).

## Playbook de Resolução
1. Executar `istioctl analyze` para detectar conflitos.
2. Ajustar DestinationRule com `tls: mode: ISTIO_MUTUAL`.
3. Atualizar certificados via Istio CA ou integração com Key Vault.
4. Revisar Gateway/VirtualService para portas corretas.
5. Monitorar com `istio_requests_total` após correção.

## Boas Práticas Preventivas
- Versionar manifests Istio em GitOps.
- Testar roteamento em ambiente canário antes de produção.
- Configurar alertas `istio_requests_total{response_code=~"5.."}`.
- Sincronizar versão do add-on Istio com releases LTS.

## Labs Relacionados
- `labs/03-managed-istio`.
- Sessão Dia 2 – Observabilidade e Segurança.

## Referências
- [Istio on AKS](https://learn.microsoft.com/azure/aks/istio-about)
- [Istio troubleshooting guide](https://istio.io/latest/docs/ops/common-problems/)
