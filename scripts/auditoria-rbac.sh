#!/usr/bin/env bash
set -euo pipefail

OUTPUT_FILE=${1:-"rbac-report-$(date +%Y%m%dT%H%M%S).csv"}

kubectl get clusterrolebindings -o json | jq -r '
  ["binding","roleRef","subjects"] +
  (.items[] | [
    .metadata.name,
    (.roleRef.kind + "/" + .roleRef.name),
    (if .subjects then (.subjects | map(.kind + ":" + .name) | join(";")) else "" end)
  ]) | @csv
' > "${OUTPUT_FILE}"

echo "Relatório salvo em ${OUTPUT_FILE}"
