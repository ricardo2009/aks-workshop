# Segurança no AKS

## Objetivo
Estabelecer um baseline de segurança para clusters AKS da Caixa, cobrindo desde controles básicos até práticas avançadas de zero trust.

## Visão em camadas

### Fundamentos
- **Superfície de ataque reduzida**: clusters privados com `authorizedIpRanges` restrito a jump hosts.
- **RBAC rigoroso**: separar perfis `admin`, `dev`, `ops` com mínimos privilégios.
- **Logs sempre ativos**: Azure Monitor + Defender para Containers.

### Intermediário
- **Segurança de imagem**:
  - Scanner automático (Defender, Aqua, Trivy) integrado ao pipeline.
  - Repositórios ACR com `content-trust` e `soft delete` ativados.
- **Runtime**:
  - Defender para Containers com políticas de alerta, incluindo execuções suspeitas e privilégio excessivo.
  - Pod Security Standards (baseline `restricted`).
- **Segurança de dados**:
  - Armazenamento criptografado com chaves gerenciadas pela Caixa (CMK) e `encryptionAtHost`.
  - Integração com Key Vault via CSI driver.

### Avançado
- **Zero Trust**: inspeção de tráfego com Azure Firewall Premium, TLS inspection, políticas DLP.
- **Sigstore / Cosign**: assinatura de imagens e verificação em admission webhooks.
- **OPA Gatekeeper**: políticas custom (ex: impedir `hostNetwork`, `hostPath`).
- **Security Posture**: uso de Azure Security Benchmark v3 com dashboards em `dashboards_alerts/security`. 

## Checklist Caixa
1. Defender for Containers habilitado com planos `Kubernetes` e `Registries`.
2. Azure Policy `baseline` aplicada (ver `policy_compliance/baseline-policies.md`).
3. Imagens somente de registries aprovados (`acrprodcaixa.azurecr.io`).
4. Segredos sensíveis fora de `ConfigMaps`/`Secrets` simples (usar Key Vault).
5. Vulnerabilities triadas semanalmente com SLA definido.

## Boas práticas
- Automatize varredura de cluster com `kubescape` ou `kube-bench` e versionamento dos relatórios.
- Use `NetworkPolicy` para segmentar ambientes (internet, middle, backend).
- Treine equipes com simulações de incidente (phishing, credenciais comprometidas).

## Referências
- [AKS security baseline](https://learn.microsoft.com/azure/architecture/reference-architectures/containers/aks/secure-baseline-aks)
- [Defender for Containers](https://learn.microsoft.com/azure/defender-for-cloud/defender-for-containers-introduction)
- [Azure Policy samples for AKS](https://learn.microsoft.com/azure/aks/policy-reference)
