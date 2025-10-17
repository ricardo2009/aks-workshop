#!/usr/bin/env bash
set -euo pipefail

kubectl apply -f ../manifests/volumesnapshot.yaml
kubectl wait volumesnapshot/sqlserver-data-snapshot -n financeiro --for=jsonpath='{.status.readyToUse}'=true --timeout=5m

echo "[INFO] Snapshot criado com sucesso."
