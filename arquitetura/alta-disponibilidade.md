# Alta Disponibilidade e Recuperação de Desastres no AKS

## Objetivo
Definir estratégias de resiliência para workloads críticos da Caixa, garantindo continuidade de serviço diante de falhas de zona, região ou componentes internos do cluster.

## Framework de Resiliência
1. **Prevenir**: design adequado, redundância e monitoramento.
2. **Detectar**: observabilidade e alertas acionáveis.
3. **Responder**: playbooks e automações de mitigação.
4. **Recuperar**: procedimentos de restauração e testes periódicos.

## Camadas de conhecimento

### Básico
- Habilite **Availability Zones** para control plane (quando disponível) e node pools.
- Use ao menos dois node pools: `system` (mín. 3 nós) e `user` com escala automática.
- Configure *pod disruption budgets* (PDB) e *readiness probes*.

### Intermediário
- **Upgrades resilientes**: utilize `az aks nodepool upgrade --max-surge` para controlar rotação de nós.
- **Multi-região ativa-passiva**: replicar dados com Azure SQL/Cache e automatizar failover via Traffic Manager/Front Door.
- **Backups**:
  - Velero para objetos Kubernetes + snapshots Azure Disk.
  - Backup de configurações (Helm release values, YAMLs) versionado em Git.
- **Chaos Engineering**: rodar experimentos com Azure Chaos Studio para validar limites.

### Avançado
- **Active-active multi cluster**: usar GitOps para manter configuração em sincronia e políticas de roteamento global.
- **Cluster API upgrades**: planejar testes de compatibilidade API `--control-plane-only` antes de atualizar pools.
- **SLI/SLO**: definir metas (ex: disponibilidade 99,95%, MTTR < 15 min) e rastrear via dashboards.

## Checklist Caixa
1. Zonas 1,2,3 ativas nos node pools de produção.
2. Política de upgrade `Surge=50%` documentada e testada trimestralmente.
3. Playbook de incidentes disponível em `troubleshooting/upgrades.md`.
4. Laboratórios de DR semestrais com relatório arquivado em `scenarios/`.
5. Alertas críticos integrados ao Centro de Operações Caixa (NOC/SOC).

## Boas práticas
- Acompanhar métricas `node_ready`, `kube_node_status_condition` e `pod_disruption_budget_evictions`.
- Automatizar runbooks de `az aks nodepool upgrade` com validação pós-upgrade.
- Simular perda de zona via escalonamento manual de node pools.

## Referências
- [Best practices for high availability in AKS](https://learn.microsoft.com/azure/aks/operator-best-practices-multi-region)
- [Plan for disaster recovery in AKS](https://learn.microsoft.com/azure/aks/operator-best-practices-cluster-security#disaster-recovery)
