# Lab de Reprodução – Latência DNS

## Objetivo
Simular misconfiguration no CoreDNS para demonstrar impacto em latência e resolução de nomes internos.

## Passos
1. Aplicar ConfigMap incorreto:
   ```bash
   kubectl apply -f lab_reproducao/coredns-misconfig.yaml
   kubectl rollout restart deployment/coredns -n kube-system
   ```
2. Executar script de teste:
   ```bash
   bash lab_reproducao/test-dns.sh
   ```
3. Observar métricas em `monitoramento/monitoramento.md` (latência DNS).
4. Reverter ConfigMap com `kubectl apply -f lab_reproducao/coredns-restore.yaml`.

## Pré-requisitos
- Cluster AKS com permissões de administrador.
- `kubectl` apontando para o cluster.
- Namespace `financeiro` com workload de teste (pode usar `labs/01-aks-cluster-creation/manifests/sample-app.yaml`).
