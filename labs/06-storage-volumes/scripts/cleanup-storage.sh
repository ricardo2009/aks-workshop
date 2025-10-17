#!/usr/bin/env bash
set -euo pipefail

NAMESPACE="financeiro"

kubectl delete statefulset sqlserver-ha -n "${NAMESPACE}" --ignore-not-found
kubectl delete pvc pvc-sqlserver-data -n "${NAMESPACE}" --ignore-not-found
kubectl delete volumesnapshot sqlserver-data-snapshot -n "${NAMESPACE}" --ignore-not-found
kubectl delete secret sqlserver-secret -n "${NAMESPACE}" --ignore-not-found
kubectl delete storageclass managed-premium-retain --ignore-not-found

echo "[INFO] Recursos removidos. Avalie volumes órfãos no portal Azure." 
