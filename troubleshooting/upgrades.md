# Troubleshooting – Upgrades de Cluster AKS

## Objetivo
Orientar execuções seguras de upgrade de control plane e node pools no AKS, minimizando indisponibilidades em ambientes bancários.

## Sintomas Comuns
- `az aks upgrade` falha com incompatibilidades de API.
- Pods críticos evictados sem respeitar PDB.
- Serviços indisponíveis durante upgrade de node pool.
- Add-ons (ex: KEDA, AGIC) não retornam após upgrade.

## Diagnóstico Passo a Passo
1. **Planejar versão alvo**
   ```bash
   az aks get-upgrades --resource-group rg-aks-caixa-prod --name aks-caixa-prod
   ```
2. **Checar APIs depreciadas**
   ```bash
   kubectl get --raw / | jq '.paths | keys[]' | rg 'beta'
   ```
   Utilize `kubescape`/`pluto` para identificar recursos removidos.
3. **Validar PDB e readiness**
   ```bash
   kubectl get pdb -A
   kubectl get nodes -o wide
   ```
4. **Executar upgrade control-plane**
   ```bash
   az aks upgrade --resource-group rg-aks-caixa-prod --name aks-caixa-prod --control-plane-only --kubernetes-version <versao>
   ```
5. **Upgrade node pool com max-surge**
   ```bash
   az aks nodepool upgrade \
     --resource-group rg-aks-caixa-prod \
     --cluster-name aks-caixa-prod \
     --name np-prod \
     --kubernetes-version <versao> \
     --max-surge 33%
   ```
6. **Monitorar**
   ```bash
   watch kubectl get nodes
   kubectl get events -A --sort-by=.lastTimestamp | tail -n 20
   ```

## Linha Investigativa (kubectl + az)
| Ordem | Comando | Objetivo | Como interpretar |
|-------|---------|----------|------------------|
| 1 | `az aks get-upgrades --resource-group <rg> --name <cluster>` | Confirmar janela suportada e versões disponíveis. | Versão alvo deve estar listada em `controlPlaneProfile.upgrades`. |
| 2 | `kubectl get nodes -Lkubernetes.azure.com/nodepool -o wide` | Mapear pools, versões e zonas. | Versões diferentes no mesmo cluster indicam upgrade parcial. |
| 3 | `kubectl get pods -A --field-selector=status.phase!=Running` | Identificar workloads não saudáveis antes do upgrade. | Pods `Pending`/`CrashLoop` devem ser estabilizados previamente. |
| 4 | `kubectl get pdb -A` | Garantir políticas de interrupção adequadas. | `MIN AVAILABLE` >= 1 assegura alta disponibilidade. |
| 5 | `az aks upgrade --control-plane-only` (dry-run com `--no-wait` + `--yes`) | Validar pré-requisitos antes de executar. | Erros retornam imediatamente (ex.: add-ons incompatíveis). |
| 6 | `kubectl drain <node> --ignore-daemonsets --delete-emptydir-data --force` | Testar cordon/drain em nó único. | Verificar se PDB impede drain; necessário ajustar antes do upgrade. |
| 7 | `kubectl get node <node> -o jsonpath='{.metadata.labels.kubernetes\.azure\.com/mode}'` | Confirmar se nó é `system` ou `user`. | Pools `system` devem ser atualizados primeiro. |
| 8 | `az aks nodepool upgrade --name <pool> --max-surge 33% --no-wait` + `watch kubectl get nodes` | Acompanhar progresso e substituição de nós. | Nós velhos aparecem `NotReady,SchedulingDisabled`; monitorar até remoção. |
| 9 | `kubectl get mutatingwebhookconfigurations` | Checar webhooks que podem bloquear upgrades. | Webhooks indisponíveis podem impedir criação de novos pods durante upgrade. |

## Ferramentas
- `az aks`, `kubectl`, `pluto`, `kubescape`.
- Azure Monitor (alertas upgrade window).

## Exemplos de Outputs
- Erro de API depreciada:
  ```text
  error: unable to recognize "deploy.yaml": no matches for kind "Ingress" in version "extensions/v1beta1"
  ```
- Resultado upgrade:
  ```text
  Upgrade succeeded with warnings: Node pool np-prod requires manual upgrade.
  ```

## Causas Raiz Frequentes
- Recursos legados (`extensions/v1beta1`) ainda implantados.
- Falta de `podDisruptionBudget` impedindo drain seguro.
- `maxPods` alto dificultando criação de nós adicionais.
- Add-ons não compatíveis com versão alvo.

## Playbook de Resolução
1. Rodar `kubectl api-resources --deprecated=true` e atualizar manifests.
2. Criar/ajustar PDBs antes do upgrade.
3. Utilizar `az aks nodepool upgrade --node-image-only` antes do upgrade de versão.
4. Validar add-ons (KEDA, AGIC, Istio) em ambiente de staging.
5. Registrar incidentes e tempo de indisponibilidade em `README_REVIEW.md`.

## Boas Práticas Preventivas
- Manter clusters uma versão atrás da GA.
- Habilitar auto-upgrade de patch e janela de manutenção.
- Documentar matriz de compatibilidade em `arquitetura/alta-disponibilidade.md`.
- Executar upgrades fora de horários críticos (janela noturna).

## Labs Relacionados
- `labs/01-aks-cluster-creation` (baseline).
- Sessão Dia 2 – Troubleshooting Profundo.

## Referências
- [Upgrade AKS cluster](https://learn.microsoft.com/azure/aks/upgrade-cluster)
- [Best practices for node upgrades](https://learn.microsoft.com/azure/aks/operator-best-practices-cluster-upgrades)
