#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<USAGE
Uso: $0 --environment <nome> --region <regiao> [--resource-group <rg>] [--node-count <num>] [--k8s-version <versao>]

Exemplo:
  $0 --environment treinamento --region brazilsouth --resource-group rg-aks-caixa-trn --node-count 3
USAGE
}

ENVIRONMENT=""
REGION=""
RESOURCE_GROUP=""
NODE_COUNT=3
K8S_VERSION=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --environment)
      ENVIRONMENT="$2"
      shift 2
      ;;
    --region)
      REGION="$2"
      shift 2
      ;;
    --resource-group)
      RESOURCE_GROUP="$2"
      shift 2
      ;;
    --node-count)
      NODE_COUNT="$2"
      shift 2
      ;;
    --k8s-version)
      K8S_VERSION="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Parâmetro desconhecido: $1" >&2
      usage
      exit 1
      ;;
  esac
done

if [[ -z "$ENVIRONMENT" || -z "$REGION" ]]; then
  echo "--environment e --region são obrigatórios" >&2
  usage
  exit 1
fi

if [[ -z "${RESOURCE_GROUP}" ]]; then
  RESOURCE_GROUP="rg-aks-caixa-${ENVIRONMENT}"
fi

CLUSTER_NAME="aks-caixa-${ENVIRONMENT}"

echo "[INFO] Subscription atual: $(az account show --query 'name' -o tsv)"
echo "[INFO] Garantindo resource group ${RESOURCE_GROUP} em ${REGION}"
az group create --name "${RESOURCE_GROUP}" --location "${REGION}" --tags CostCenter=CaixaWorkshop Environment="${ENVIRONMENT}" >/dev/null

IDENTITY_NAME="id-${CLUSTER_NAME}-mi"
IDENTITY_ID=$(az identity show --name "${IDENTITY_NAME}" --resource-group "${RESOURCE_GROUP}" --query 'id' -o tsv 2>/dev/null || true)
if [[ -z "${IDENTITY_ID}" ]]; then
  echo "[INFO] Criando managed identity ${IDENTITY_NAME}"
  IDENTITY_ID=$(az identity create --name "${IDENTITY_NAME}" --resource-group "${RESOURCE_GROUP}" --location "${REGION}" --query 'id' -o tsv)
fi

CREATE_PARAMS=(
  --resource-group "${RESOURCE_GROUP}"
  --name "${CLUSTER_NAME}"
  --location "${REGION}"
  --node-count "${NODE_COUNT}"
  --enable-managed-identity
  --assign-identity "${IDENTITY_ID}"
  --network-plugin azure
  --enable-aad
  --enable-azure-rbac
  --enable-private-cluster
  --enable-managed-prometheus
  --enable-azure-monitor-metrics
  --enable-defender
  --tags CostCenter=CaixaWorkshop Environment="${ENVIRONMENT}"
)

SUBNET_ID=$(az network vnet subnet list --resource-group "${RESOURCE_GROUP}" --query "[0].id" -o tsv 2>/dev/null || echo "")
if [[ -n "${SUBNET_ID}" ]]; then
  CREATE_PARAMS+=(--vnet-subnet-id "${SUBNET_ID}")
else
  echo "[WARN] Nenhuma subnet encontrada no resource group ${RESOURCE_GROUP}. Configure manualmente após a criação."
fi

if [[ -n "${K8S_VERSION}" ]]; then
  CREATE_PARAMS+=(--kubernetes-version "${K8S_VERSION}")
fi

if az aks show --resource-group "${RESOURCE_GROUP}" --name "${CLUSTER_NAME}" >/dev/null 2>&1; then
  echo "[INFO] Cluster ${CLUSTER_NAME} já existe. Validando atualizações..."
  az aks update "${CREATE_PARAMS[@]}" >/dev/null
else
  echo "[INFO] Criando cluster ${CLUSTER_NAME}"
  az aks create "${CREATE_PARAMS[@]}"
fi

echo "[INFO] Habilitando auto-upgrade de patch"
az aks update --resource-group "${RESOURCE_GROUP}" --name "${CLUSTER_NAME}" --auto-upgrade-channel patch >/dev/null

echo "[INFO] Configurando credenciais"
az aks get-credentials --resource-group "${RESOURCE_GROUP}" --name "${CLUSTER_NAME}" --overwrite-existing

echo "[INFO] Cluster pronto. Execute 'kubectl get nodes' para validar."
