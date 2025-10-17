# Controle de Acesso e Identidade no AKS

## Objetivo
Estabelecer diretrizes para autenticação e autorização em clusters AKS da Caixa, com foco em integração corporativa Azure AD, segregação de funções e proteção de segredos.

## Três camadas de entendimento

### Começando
- **Autenticação**: todos os usuários devem utilizar `az login` com MFA corporativo antes de interagir com o cluster.
- **Autorização**: o AKS suporta RBAC nativo. Utilize grupos Azure AD (ex: `grp-aks-caixa-admins`) mapeados para `ClusterRole`/`Role`.
- **Ferramentas**: `kubectl auth can-i`, `az aks get-credentials` com a flag `--admin` restrita a equipe SRE.

### Intermediário
- **Managed Identities**:
  - *System-assigned* para operações do cluster (ex: criação de Load Balancer).
  - *User-assigned* para workloads que precisam acessar recursos externos.
- **Azure RBAC for Kubernetes**: habilitar `--enable-aad` e `--enable-azure-rbac` para mapear papéis Azure diretamente para autorizações Kubernetes.
- **Secret management**:
  - Use `Secrets Store CSI Driver` com Azure Key Vault.
  - Habilite rotação automática e monitoramento de expiração.
- **Auditoria**:
  - Ativar `audit-policy` personalizado e encaminhar logs para Log Analytics.

### Avançado
- **Workload Identity (OIDC)**: substitui Pod Identity, usando federated credentials no Azure AD para pods acessarem recursos com tokens OIDC.
- **mTLS end-to-end**: usar Istio/Linkerd para tráfego este-oeste, integrando certificados ao Key Vault.
- **Just-in-time access**: Azure AD PIM para conceder acesso temporário a roles privilegiadas.
- **Policy enforcement**: usar Azure Policy (ex: `allowedAADClientIDsForVolumeMounts`) e Gatekeeper para regras customizadas.

## Checklist Caixa
1. Azure AD integrado com RBAC Kubernetes em todos os clusters.
2. Desabilitar `local accounts` e `Kubernetes Dashboard` público.
3. Auditar `ClusterRoleBinding` mensalmente via `scripts/auditoria-rbac.sh`.
4. Segredos críticos armazenados no Key Vault com rótulos de expiração.
5. Habilitar `Defender for Containers` para detectar anomalias de credenciais.
6. Logs de auditoria encaminhados para SIEM corporativo.

## Boas práticas
- Utilize namespaces para separar workloads e aplique `RoleBindings` específicos.
- Use `kubectl auth can-i --as <user>` para validar políticas.
- Documente procedimentos de acesso emergencial (break-glass) em `policy_compliance/`.

## Referências
- [Azure AD integration with AKS](https://learn.microsoft.com/azure/aks/managed-aad)
- [Workload Identity](https://learn.microsoft.com/azure/aks/workload-identity-overview)
- [Azure Policy for AKS](https://learn.microsoft.com/azure/aks/policy-reference)
