# Fundamentos do Azure Kubernetes Service (AKS)

## Objetivo
Guiar arquitetos e operadores da Caixa Econômica Federal pelos componentes essenciais do AKS, destacando responsabilidades compartilhadas, decisões de configuração e implicações para workloads bancários de missão crítica.

## Visão Progressiva

### 1. Para quem está começando
- **Conceito**: o AKS é uma plataforma gerenciada de Kubernetes. Pense nele como um “condomínio seguro” onde a Microsoft mantém áreas comuns (control plane) e você cuida dos apartamentos (nós worker e aplicações).
- **Componentes básicos**:
  - *Control plane gerenciado*: API Server, etcd, scheduler, controllers.
  - *Node pools*: conjuntos de VMs Linux/Windows que executam os pods.
  - *Add-ons gerenciados*: Azure Monitor, Azure Policy, KEDA, Istio, AGIC.
- **Responsabilidade compartilhada**:
  - Microsoft: saúde do control plane, upgrades automáticos, SLA.
  - Caixa: nós worker, workloads, segurança, monitoramento e dados.

### 2. Nível intermediário
- **Modelos de identidade**: Managed Identity para o cluster (`identity`), para o kubelet (`kubeletIdentity`) e identidades específicas para workload (pod-managed identity ou workload identity).
- **Integrações Azure**:
  - **Azure Key Vault**: secret store CSI driver.
  - **Azure Monitor**: coleta de métricas (AMA) e logs (Container Insights).
  - **Application Gateway**: com AGIC para ingress layer 7.
- **Clusters híbridos**: uso de Azure Arc para gerenciamento centralizado de clusters on-premises.
- **Ciclos de vida**: canal de atualização (patch, minor), auto-upgrade e manutenção planejada.

### 3. Especialistas
- **Hardening do plano de controle**:
  - Habilitar **API Server Authorized IP ranges** ou Private Cluster.
  - Revisar *network policies* e *Azure Policy* para enforcement de segurança.
- **Automação**:
  - Infraestrutura como código (Bicep/Terraform) com pipelines Azure DevOps/GitHub Actions.
  - Uso de *Flux v2* ou *Argo CD* para GitOps.
- **FinOps**: análise de custos por namespace/workload via tags, insights do Cost Management e métricas customizadas.
- **Compliance**: aderência a Baseline Caixa, Bacen e LGPD.

## Checklist Caixa para novos clusters
1. Naming convention `aks-caixa-<ambiente>-<região>`.
2. Azure CNI + sub-rede dedicada com /23 ou maior.
3. Control plane Private + Azure RBAC para Kubernetes habilitado.
4. Auto-upgrade `patch` ativado; `minor` sob aprovação.
5. Add-ons habilitados: Azure Monitor, Defender for Containers, KEDA (conforme necessidade).
6. Node pool padrão `Standard_D4ds_v5` (ou superior) com disponibilidade zonal.
7. Pool de sistema separado do pool de usuário.
8. Network policy baseada em Azure Network Policy Manager ou Calico.
9. RBAC integrado ao Azure AD; grupos alinhados aos papéis Caixa.
10. Backups e snapshots das workloads stateful documentados.

## Boas práticas
- Centralize logs e métricas em Log Analytics dedicado com DCR customizada.
- Automatize criação de clusters via `infra_as_code/`.
- Documente limites e quotas (pods por nó, IPs, discos) em `README_REVIEW.md`.
- Utilize *node taints* e *pod tolerations* para workloads críticos.
- Realize *chaos testing* periódico para validar resiliência.

## Referências Oficiais
- [Azure Kubernetes Service documentation](https://learn.microsoft.com/azure/aks/)
- [AKS baseline architecture](https://learn.microsoft.com/azure/architecture/reference-architectures/containers/aks/secure-baseline-aks)
- [Shared responsibility in AKS](https://learn.microsoft.com/azure/aks/concepts-security)
