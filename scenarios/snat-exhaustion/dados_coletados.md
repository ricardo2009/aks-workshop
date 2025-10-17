# Dados Coletados

## Métricas e Logs
- Azure Monitor: métrica `SNATPortUtilization` em 98% na subnet `aks-prod-snet`.
- Logs do `pix-gateway`: `dial tcp: connect: connection timed out`.
- Métricas `pod_allocated_ips / pod_capacity_ips` estáveis (0.42) – sem exaustão de IPs.

## Eventos Kubernetes
```bash
kubectl describe pod -n pagamentos pix-gateway-55c8f5f8d9-ks2sm | rg -C4 Failed
```
_Resultado:_ nenhum evento de agendamento; apenas `Readiness probe failed` por timeout.

## Inspeção do Load Balancer
```bash
az network lb outbound-rule show \
  --name aksOutboundRule \
  --resource-group rg-aks-caixa-prod \
  --lb-name kubernetes \
  --query "{ports:backendAddressPool.configurations[0].outboundPorts, idle: idleTimeoutInMinutes}" -o tsv
```
_Resultado:_ `1024 4` (apenas 1.024 portas, timeout idle 4 minutos).

## Traces do App Gateway
```bash
az network application-gateway show \
  --resource-group rg-network-prod \
  --name agw-caixa-prod \
  --query "{backendHealth: backendAddressPools[].backendHttpSettingsCollection[].pickHostNameFromBackendAddress}" -o json
```
_Resultado:_ nenhum erro no backend HTTP do App Gateway.

## Testes de Conectividade
```bash
kubectl exec -n pagamentos deploy/pix-gateway -- sh -c 'for i in $(seq 1 5); do curl -sS -m 2 https://api-pix.bcb.gov.br/health; done'
```
_Resultado:_ 3 timeouts em 5 tentativas durante pico.
