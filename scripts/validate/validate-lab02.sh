#!/usr/bin/env bash
set -euo pipefail

CLUSTER="${AKS_CLUSTER:-aks-caixa-trn}"
RESOURCE_GROUP="${RESOURCE_GROUP:-rg-aks-caixa-trn}"

echo "[INFO] Validando recursos de monitoramento gerenciado"

if ! az aks show --name "${CLUSTER}" --resource-group "${RESOURCE_GROUP}" --query "addonProfiles.azureMonitorMetrics.enabled" -o tsv 2>/dev/null | grep -qi true; then
  echo "[WARN] Azure Monitor Metrics não habilitado para ${CLUSTER}"
else
  echo "[PASS] Azure Monitor Metrics habilitado"
fi

if ! kubectl get configmap ama-metrics-settings-configmap -n kube-system >/dev/null 2>&1; then
  echo "[FAIL] ConfigMap ama-metrics-settings-configmap ausente"
  exit 1
fi

echo "[PASS] ConfigMap ama-metrics-settings-configmap presente"

echo "[INFO] Verificando pods do agente"
if kubectl get pods -n kube-system -l rsName=ama-logs | grep -q Running; then
  echo "[PASS] Pods ama-logs em execução"
else
  echo "[WARN] Nenhum pod ama-logs em Running"
fi
