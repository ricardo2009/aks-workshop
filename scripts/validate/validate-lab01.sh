#!/usr/bin/env bash
set -euo pipefail

CLUSTER="${1:-${AKS_CLUSTER:-aks-caixa-trn}}"
RESOURCE_GROUP="${2:-${RESOURCE_GROUP:-rg-aks-caixa-trn}}"

if ! az aks show --name "${CLUSTER}" --resource-group "${RESOURCE_GROUP}" >/dev/null 2>&1; then
  echo "[FAIL] Cluster ${CLUSTER} não encontrado no resource group ${RESOURCE_GROUP}" >&2
  exit 1
fi

echo "[PASS] Cluster ${CLUSTER} encontrado"

NODE_COUNT=$(az aks show --name "${CLUSTER}" --resource-group "${RESOURCE_GROUP}" --query 'agentPoolProfiles[0].count' -o tsv)
if [[ "${NODE_COUNT}" -lt 3 ]]; then
  echo "[WARN] Node pool principal com menos de 3 nós (${NODE_COUNT})"
else
  echo "[PASS] Node pool possui ${NODE_COUNT} nós"
fi

if kubectl get nodes >/dev/null 2>&1; then
  echo "[PASS] kubectl conectado ao cluster"
else
  echo "[FAIL] kubectl não consegue listar nós" >&2
  exit 1
fi
