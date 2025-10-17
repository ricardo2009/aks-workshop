#!/usr/bin/env bash
set -euo pipefail

for bin in az kubectl jq python3; do
  if ! command -v "$bin" >/dev/null 2>&1; then
    echo "$bin não encontrado. Instale antes de executar este validador." >&2
    exit 1
  fi
done

CLUSTER_NAME=${CLUSTER_NAME:-aks-caixa-trn}
RESOURCE_GROUP=${RESOURCE_GROUP:-rg-aks-caixa-trn}
LB_NAME=${LB_NAME:-kubernetes}

if [[ ${FETCH_KUBECONFIG:-false} == "true" ]]; then
  echo "Atualizando kubeconfig para o cluster ${CLUSTER_NAME}..."
  az aks get-credentials --name "$CLUSTER_NAME" --resource-group "$RESOURCE_GROUP" --overwrite-existing >/dev/null
fi

printf "[1/4] Coletando utilização de IPs dos nodes...\n"
kubectl get nodes -o wide | awk 'NR==1 || {print $1, $6, $7}'

printf "[2/4] Calculando métricas de IP de pods...\n"
ALLOCATED=$(kubectl get pods -A -o json | jq '[.items[].status.podIP] | length')
CAPACITY=$(kubectl get nodes -o json | jq '[.items[].status.capacity["pods"] | tonumber] | add')
if [[ ${CAPACITY} -eq 0 ]]; then
  echo "Capacidade de pods não encontrada." >&2
  exit 1
fi
PERCENT=$(python3 - <<PY
allocated=${ALLOCATED}
capacity=${CAPACITY}
print(round((allocated/capacity)*100, 2))
PY
)
printf "Pods alocados: %s/%s (%.2f%%)\n" "$ALLOCATED" "$CAPACITY" "$PERCENT"

printf "[3/4] Métrica SNATPortUtilization (últimos 30 min)...\n"
LB_ID=$(az network lb show --name "$LB_NAME" --resource-group "$RESOURCE_GROUP" --query id -o tsv)
az monitor metrics list \
  --resource "$LB_ID" \
  --metric SNATPortUtilization \
  --interval PT5M \
  --timespan PT30M \
  --aggregation Average \
  --top 5 \
  --output table

printf "[4/4] Validando Network Policies aplicadas...\n"
kubectl get networkpolicy -A

echo "Validação concluída. Revise alertas acima de 70% em SNAT ou capacidade de pods." 
