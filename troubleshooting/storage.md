# Troubleshooting – Storage e Volumes Persistentes

## Objetivo
Diagnosticar e solucionar problemas de volumes persistentes em clusters AKS, incluindo Azure Disk/File e snapshots.

## Sintomas Comuns
- PVC em estado `Pending` ou `Lost`.
- Eventos `FailedAttachVolume` ou `FailedMount`.
- Volumes com `reclaimPolicy` incorreta removendo dados prematuramente.
- Snapshots não prontos (`readyToUse=false`).
- Pods reiniciando com `ReadOnly file system`.

## Diagnóstico Passo a Passo
1. **Verificar estado do PVC/PV**
   ```bash
   kubectl get pvc -A
   kubectl describe pvc pvc-sqlserver-data -n financeiro
   ```
2. **Checar eventos do pod**
   ```bash
   kubectl describe pod sqlserver-ha-0 -n financeiro | grep -A5 MountVolume
   ```
3. **Validar StorageClass**
   ```bash
   kubectl get storageclass
   kubectl describe storageclass managed-premium-retain
   ```
4. **Inspecionar disco no Azure**
   ```bash
   az disk show --ids <DISK_ID>
   ```
5. **Snapshots**
   ```bash
   kubectl describe volumesnapshot sqlserver-data-snapshot -n financeiro
   ```

## Linha Investigativa (kubectl + azure)
| Ordem | Comando | Objetivo | Como interpretar |
|-------|---------|----------|------------------|
| 1 | `kubectl get pvc -n <namespace> -o wide` | Identificar status atual, volume associado e StorageClass. | `Pending` indica ausência de PV; `Bound` com volume incorreto exige correção manual. |
| 2 | `kubectl describe pvc <pvc> -n <namespace>` | Revisar eventos detalhados e capacity. | Mensagens `waiting for first consumer` sugerem `volumeBindingMode=WaitForFirstConsumer`. |
| 3 | `kubectl get pv <pv>` | Validar estado e `claimRef`. | `Released` sem `claimRef` aponta para detach manual necessário. |
| 4 | `kubectl describe pod <stateful-pod>` | Identificar erros `FailedAttachVolume` e ponto de montagem. | `timed out waiting for the condition` implica em verificar permissões ou zona. |
| 5 | `kubectl get volumesnapshot -n <namespace>` | Confirmar pipeline de snapshots. | `readyToUse=false` demanda análise da controladora. |
| 6 | `az disk show --ids <DISK_ID>` | Checar estado/lock no Azure. | `diskState` diferente de `Attached`/`Reserved` denuncia problema de detach. |
| 7 | `az resource show --ids <managed-identity>` e `az role assignment list` | Validar RBAC para recursos de storage. | Falta de permissão `Disk Backup Reader`/`Contributor` impede snapshot. |
| 8 | `kubectl describe volumesnapshotclass <classe>` | Confirmar driver (`csi`) e secrets. | Config incorreta gera `SnapshotFailed`. |

## Ferramentas
- `kubectl`, `az disk`, `az storage account`.
- Azure Monitor logs (`KubePVInventory`, `KubePVCInventory`).

## Exemplos de Outputs
- Evento de attach:
  ```text
  Warning  FailedAttachVolume  unable to attach or mount volumes: timeout expired waiting for volumes to attach
  ```
- Snapshot com erro:
  ```text
  Warning  SnapshotFailed  VolumeSnapshotController  failed to create snapshot due to AuthorizationFailed
  ```

## Causas Raiz Frequentes
- Falta de permissões Managed Identity para acessar `Microsoft.Compute/disks`.
- `diskEncryptionSet` não associado ao cluster.
- Tentativa de montar PVC RWO em múltiplos pods simultaneamente.
- StorageClass com `allowVolumeExpansion: false` impedindo resize.

## Playbook de Resolução
1. Confirmar RBAC e conceder permissões `Contributor` na assinatura do disco.
2. Ajustar StorageClass (reclaimPolicy, encryption set).
3. Forçar reattach: excluir pod stateful (`kubectl delete pod <pod> --grace-period=0`).
4. Para snapshots, validar `VolumeSnapshotClass` e credenciais Azure.
5. Registrar incidente e gerar postmortem em `scenarios/` se dados forem afetados.

## Boas Práticas Preventivas
- Usar `reclaimPolicy: Retain` para dados críticos.
- Documentar IDs de `diskEncryptionSet` em `infra_as_code/`.
- Configurar alertas para eventos `FailedAttachVolume` recorrentes.
- Testar restauração de snapshot trimestralmente.

## Labs Relacionados
- `labs/06-storage-volumes`.
- `agenda/agenda.md` – sessão Storage Dia 1.

## Referências
- [Persistent storage in AKS](https://learn.microsoft.com/azure/aks/concepts-storage)
- [Troubleshoot storage issues](https://learn.microsoft.com/azure/aks/troubleshooting-storage-issues)
