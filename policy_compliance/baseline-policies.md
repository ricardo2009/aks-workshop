# Baseline de Azure Policy para AKS

## Objetivo
Definir o conjunto mínimo de políticas que devem ser aplicadas aos clusters AKS da Caixa para garantir conformidade com exigências regulatórias e melhores práticas de segurança.

## Policies recomendadas

| Categoria | Nome da Policy | Ação | Observações |
|-----------|----------------|------|-------------|
| Segurança | `Kubernetes clusters should only allow approved AAD groups to access the API server` | AuditIfNotExists | Garantir RBAC integrado ao Azure AD. |
| Segurança | `Kubernetes clusters should have local accounts disabled` | Deny | Impede uso de `--admin` exceto em break-glass documentado. |
| Rede | `Kubernetes clusters should be deployed with Azure CNI` | Deny | Evita Kubenet em ambientes produtivos. |
| Rede | `Kubernetes clusters should enable private clusters` | AuditIfNotExists | Alertar clusters públicos. |
| Storage | `Kubernetes clusters should not allow privileged containers` | Deny | Exigir justificativa em `exceptions/`. |
| Observabilidade | `Kubernetes clusters should enable Azure Monitor` | AuditIfNotExists | Cruzar com `monitoramento/`. |
| Compliance | `Kubernetes clusters should have Defender for Containers enabled` | AuditIfNotExists | Integrar com SOC Caixa. |

## Deploy com Azure Policy
```bash
az policy assignment create \
  --name aks-caixa-baseline \
  --scope /subscriptions/<SUBSCRIPTION_ID>/resourceGroups/rg-aks-caixa-prod \
  --policy-set-definition aksBaselineSetDefinition \
  --params @policy_compliance/parameters/aks-baseline.json
```

> Ajuste `aksBaselineSetDefinition` conforme catálogo corporativo. Utilize `policy_compliance/exceptions/` para registrar aprovações temporárias.

## Referências
- [Azure Policy for AKS](https://learn.microsoft.com/azure/aks/policy-reference)
- [Azure Security Benchmark](https://learn.microsoft.com/security/benchmark/azure/baselines/aks-security-baseline)
