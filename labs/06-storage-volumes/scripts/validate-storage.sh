#!/usr/bin/env bash
set -euo pipefail

NAMESPACE="financeiro"

PVC_STATUS=$(kubectl get pvc pvc-sqlserver-data -n "${NAMESPACE}" -o jsonpath='{.status.phase}' 2>/dev/null || echo "NotFound")
if [[ "${PVC_STATUS}" != "Bound" ]]; then
  echo "[FAIL] PVC pvc-sqlserver-data não está Bound (${PVC_STATUS})"
  exit 1
fi

echo "[PASS] PVC Bound"

SNAP_READY=$(kubectl get volumesnapshot sqlserver-data-snapshot -n "${NAMESPACE}" -o jsonpath='{.status.readyToUse}' 2>/dev/null || echo "false")
if [[ "${SNAP_READY}" != "true" ]]; then
  echo "[WARN] Snapshot sqlserver-data-snapshot ainda não está pronto"
else
  echo "[PASS] Snapshot pronto para restauração"
fi

POD_STATUS=$(kubectl get pod -l app=sqlserver-ha -n "${NAMESPACE}" -o jsonpath='{.items[0].status.phase}' 2>/dev/null || echo "NotFound")
if [[ "${POD_STATUS}" != "Running" ]]; then
  echo "[FAIL] Pod sqlserver-ha não está Running (${POD_STATUS})"
  exit 1
fi

echo "[PASS] StatefulSet ativo"
