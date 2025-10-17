#!/usr/bin/env bash
set -euo pipefail

echo "[INFO] Testando resolução interna"
kubectl run dns-debug --image=ghcr.io/ricardo2009/dns-tools:latest --restart=Never --command -- sleep 300 >/dev/null 2>&1 || true
kubectl wait pod/dns-debug --for=condition=Ready --timeout=60s >/dev/null

for host in api.pix.caixa.svc.cluster.local kubernetes.default.svc.cluster.local; do
  echo "--- ${host} ---"
  kubectl exec dns-debug -- sh -c "time dig +tries=1 +time=1 ${host}" | sed 's/^/    /'
done

echo "[INFO] Limpando pod temporário"
kubectl delete pod dns-debug --now >/dev/null
