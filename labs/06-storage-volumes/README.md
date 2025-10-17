# Lab 06 – Storage e Volumes Persistentes

## Objetivo
Aprender a provisionar volumes persistentes para workloads bancários, garantir políticas de retenção e validar recuperação rápida.

## Pré-requisitos
- Cluster criado no Lab 01.
- Acesso ao Azure Storage (Disk e File) com permissões de Contributor.
- Subscription com `DiskEncryptionSet` disponível (opcional para CMK).

## Passos resumidos
1. Executar `scripts/deploy.sh` para criar namespace, secrets e StatefulSet.
2. Conferir PVC `pvc-sqlserver-data` com `kubectl get pvc -n financeiro`.
3. Criar snapshot com `scripts/snapshot.sh`.
4. Restaurar em caso de falha aplicando novamente os manifests (`manifests/pvc-sqlserver.yaml`).
5. Validar estado com `scripts/validate-storage.sh`.

## Checklist
- [ ] PVC em estado `Bound`.
- [ ] Snapshot listado via `kubectl get volumesnapshot`.
- [ ] Aplicação volta a operar após restauração.

## Troubleshooting
- Consulte `troubleshooting/storage.md` para playbooks completos.

## Limpeza
```bash
bash scripts/cleanup-storage.sh
```
