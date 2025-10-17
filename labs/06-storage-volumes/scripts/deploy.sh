#!/usr/bin/env bash
set -euo pipefail

NAMESPACE="financeiro"

kubectl create namespace "${NAMESPACE}" --dry-run=client -o yaml | kubectl apply -f -

kubectl create secret generic sqlserver-secret \
  --namespace "${NAMESPACE}" \
  --from-literal=sapassword="P@ssword123!" \
  --dry-run=client -o yaml | kubectl apply -f -

kubectl apply -f ../manifests/storageclass-retain.yaml
kubectl apply -f ../manifests/pvc-sqlserver.yaml
kubectl apply -f ../manifests/statefulset-sqlserver.yaml

kubectl rollout status statefulset/sqlserver-ha -n "${NAMESPACE}" --timeout=10m

echo "[INFO] StatefulSet implantado."
