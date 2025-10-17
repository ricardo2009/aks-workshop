# Troubleshooting – Application Gateway Ingress Controller (AGIC)

## Objetivo
Fornecer um guia opinativo para diagnosticar falhas envolvendo o AGIC em clusters AKS da Caixa, garantindo disponibilidade das aplicações expostas via Azure Application Gateway.

## Sintomas Comuns
- Application Gateway reporta `Backend pool unhealthy`.
- AGIC logs contêm `failed applying AppGateway config`.
- Retorno HTTP 502/503 para clientes externos.
- Listener sem certificado válido ou porta incorreta.
- Conflito entre AGIC e NGINX Ingress em Services compartilhados.

## Diagnóstico Passo a Passo
1. **Validar estado do pod AGIC**
   ```bash
   kubectl get pods -n kube-system -l app=ingress-appgw
   kubectl logs -n kube-system deploy/ingress-appgw-controller --tail 100
   ```
2. **Checar identidade gerenciada**
   ```bash
   az role assignment list --assignee <AGIC_MANAGED_IDENTITY> --scope <APP_GW_ID>
   ```
3. **Verificar backend health**
   ```bash
   az network application-gateway show-backend-health \
     --resource-group rg-aks-caixa-prod \
     --name appgw-caixa-prod \
     --query "backendAddressPools[].backendHttpSettingsCollection[].servers"
   ```
4. **Analisar annotations do Ingress**
   ```bash
   kubectl describe ingress pix-api -n financeiro
   ```
5. **Confirmar probes** via portal ou CLI (`az network application-gateway probe show`).

## Linha Investigativa (kubectl + az)
| Ordem | Comando | Objetivo | Como interpretar |
|-------|---------|----------|------------------|
| 1 | `kubectl get pods -n kube-system -l app=ingress-appgw -o wide` | Checar saúde e distribuição do AGIC. | `CrashLoopBackOff` ou pods em um único nó indicam problema de node ou afinidade. |
| 2 | `kubectl logs -n kube-system deploy/ingress-appgw-controller --tail 100` | Capturar erros recentes. | Mensagens `authz` indicam permissão; `ApplyAppGwConfig` repetido sem sucesso mostra conflito de config. |
| 3 | `kubectl get ingress -A -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.metadata.namespace}{"\t"}{.metadata.annotations.appgw\\.ingress\\.kubernetes\\.io/backend-path-prefix}{"\n"}{end}'` | Validar annotations críticas em massa. | `null` ou vazio em host sensível sugere annotation ausente. |
| 4 | `az network application-gateway show-backend-health --resource-group <rg> --name <appgw>` | Confirmar status backend direto no App Gateway. | Servidores `Down` alinham com pods ou probes falhando; correlacionar com `kubectl describe pod`. |
| 5 | `kubectl describe svc <service> -n <ns>` | Revisar portas/selector utilizados pelo Ingress. | Porta incorreta ou selector sem pods impede health probe. |
| 6 | `az role assignment list --assignee <AGIC_MANAGED_IDENTITY> --scope <APP_GW_ID>` | Garantir RBAC completo. | Ausência de `Contributor` impede atualização de config. |
| 7 | `az network application-gateway rewrite-rule set list --resource-group <rg> --gateway-name <appgw>` | Detectar rewrites que alteram host/paths. | Regras conflitantes podem gerar 502/503. |

## Ferramentas
- `kubectl`, `az network application-gateway`, `az role assignment`.
- Azure Monitor Application Gateway logs (`ApplicationGatewayAccessLog`).
- `dashboards_alerts/appgw-overview.json`.

## Exemplos de Outputs
- Log de erro de identidade:
  ```text
  ERROR: failed applying AppGateway config: network.ApplicationGatewayBackendAddressPool cannot be null
  ```
- Backend com probe falhando:
  ```json
  {
    "address": "10.2.4.15",
    "health": "Down",
    "details": "Probe Status: 502 Bad Gateway"
  }
  ```

## Causas Raiz Frequentes
- Managed Identity sem permissão `Contributor` no App Gateway.
- Service sem annotation `appgw.ingress.kubernetes.io/backend-path-prefix` correta.
- Health probe HTTP apontando para rota que exige autenticação.
- Conflito com NGINX Ingress utilizando mesmo hostname/IP público.
- Timeout backend (pod não responde em 30s).

## Playbook de Resolução
1. Confirmar RBAC e reatribuir permissões se necessário.
2. Revisar annotations e ajustar, por exemplo:
   ```yaml
   appgw.ingress.kubernetes.io/backend-path-prefix: "/"
   appgw.ingress.kubernetes.io/health-probe-path: "/healthz"
   ```
3. Ajustar health probe no App Gateway com método/intervalo corretos.
4. Garantir que pods respondam na porta esperada (verificar `readinessProbe`).
5. Se coexistência com NGINX for necessária, usar hostnames diferentes ou `appgw.ingress.kubernetes.io/appgw-shared` para multi-site.

## Boas Práticas Preventivas
- Versionar manifests do Ingress com annotations críticas.
- Utilizar `az network application-gateway waf-policy` para segurança adicional.
- Ativar métricas `appgw_failed_requests` e alertar quando > 1%.
- Executar `kubectl get ingress -A -o yaml` em revisões periódicas buscando parâmetros incorretos.

## Labs Relacionados
- `labs/05-managed-nginx` (comparativo e fallback).
- `agenda/agenda.md` – sessão AGIC + App Gateway.
- Próximo lab dedicado (em desenvolvimento) usando `scenarios/agic-backend-timeout/`.

## Referências
- [Application Gateway ingress controller overview](https://learn.microsoft.com/azure/application-gateway/ingress-controller-overview)
- [Troubleshoot backend health in Application Gateway](https://learn.microsoft.com/azure/application-gateway/application-gateway-backend-health-troubleshooting)
