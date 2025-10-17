# Troubleshooting – Deploys Helm

## Objetivo
Resolver falhas de deploy com Helm em clusters AKS, incluindo divergência de versões, hooks problemáticos e rollback seguro.

## Sintomas Comuns
- `helm install`/`upgrade` retorna `no deployed releases` ou `has no deployed releases`.
- Hooks travam (`failed post-install hooks`).
- CRDs não atualizam (`resource version conflict`).
- `helm diff` aponta modificações inesperadas.
- `CrashLoopBackOff` imediatamente após upgrade.

## Diagnóstico Passo a Passo
1. **Checar histórico da release**
   ```bash
   helm history caixa-api -n financeiro
   ```
2. **Executar diff antes do upgrade**
   ```bash
   helm repo update
   helm diff upgrade caixa-api charts/caixa-api -n financeiro --values values/prod.yaml
   ```
3. **Analisar hooks**
   ```bash
   helm get manifest caixa-api -n financeiro | rg 'hook'
   ```
4. **Validar CRDs**
   ```bash
   kubectl get crd | grep <nome>
   kubectl describe crd <nome>
   ```
5. **Consultar eventos**
   ```bash
   kubectl get events -n financeiro --sort-by=.metadata.creationTimestamp
   ```

## Linha Investigativa (kubectl + helm)
| Ordem | Comando | Objetivo | Como interpretar |
|-------|---------|----------|------------------|
| 1 | `helm list -n <namespace>` | Confirmar releases existentes e status. | `pending-install/upgrade` indica hook preso ou erro durante deploy. |
| 2 | `helm history <release> -n <namespace>` | Identificar revisões e timestamps. | Revisão recente `FAILED` prepara para rollback. |
| 3 | `helm status <release> -n <namespace>` | Resumo dos recursos aplicados. | `last deployment` com eventos descreve ponto de falha. |
| 4 | `kubectl get pods,svc,ingress -l release=<release> -n <namespace>` | Correlacionar objetos criados pelo chart. | Recursos ausentes revelam templates condicionais não atendidos. |
| 5 | `kubectl describe job <hook-job> -n <namespace>` | Avaliar hooks (`pre/post install`). | `BackoffLimitExceeded` indica que o hook precisa de debug manual. |
| 6 | ``kubectl get events -n <namespace> --field-selector involvedObject.kind=Pod --sort-by=.lastTimestamp \| tail`` | Capturar últimas falhas relacionadas. | Ajuda a identificar `FailedMount`, `ImagePull` durante upgrade. |
| 7 | `helm diff upgrade <release> <chart> -n <namespace> --values <values>` | Antecipar mudanças. | Diferenças inesperadas exigem revisão antes do deploy. |
| 8 | `kubectl get crd <nome>` e `kubectl explain <crd>` | Validar CRDs exigidos. | Ausência impede `helm install` quando chart assume CRD pré-existente. |

## Ferramentas
- `helm` CLI com plugins `diff` e `secrets` (opcional).
- `kubectl`, `az acr` (para imagens).
- `scripts/validate/` para pós-upgrade.

## Exemplos de Outputs
- Erro de hook:
  ```text
  Error: execution error at (charts/caixa-api/templates/hooks/job.yaml:35): Migration failed
  ```
- Conflito de CRD:
  ```text
  Error: rendered manifests contain a resource that already exists. Unable to continue with install: CustomResourceDefinition "x" in namespace "" exists and cannot be imported into the current release
  ```

## Causas Raiz Frequentes
- Upgrade direto `major` sem validação de breaking changes.
- Hooks de migração com dependências não satisfeitas (ex: DB offline).
- Versões de chart divergentes entre ambientes (drift).
- Timeouts padrão insuficientes (`--timeout` baixo).

## Playbook de Resolução
1. Rodar `helm diff` e compartilhar com equipe antes do upgrade.
2. Executar hooks manualmente em ambiente de staging.
3. Atualizar CRDs primeiro (`kubectl apply -f crds/`).
4. Ajustar `--timeout` e `--atomic` para garantir rollback automático.
5. Em caso de falha, usar `helm rollback caixa-api <revision>` e investigar pods via `troubleshooting/crashloopbackoff.md`.

## Boas Práticas Preventivas
- Versionar `values.yaml` por ambiente.
- Habilitar `helm test` com testes de fumaça.
- Automatizar deploy via pipelines com aprovação manual.
- Manter catálogo de charts interno (ACR/ChartMuseum) com controle de versão.

## Labs Relacionados
- `labs/01-aks-cluster-creation` (introdução Helm).
- `troubleshooting/crashloopbackoff.md` (seguimento pós-deploy).

## Referências
- [Helm upgrade strategies](https://helm.sh/docs/helm/helm_upgrade/)
- [Troubleshooting Helm deployments](https://learn.microsoft.com/azure/aks/faq#helm)
