# Laboratórios Hands-on

Os laboratórios estão organizados de forma progressiva, permitindo que os participantes construam conhecimento do zero até operações avançadas.

## Lista de labs
1. `01-aks-cluster-creation`: criação do cluster `aks-caixa-trn` com Azure CNI e add-ons essenciais.
2. `02-managed-prometheus-grafana`: habilitação de monitoramento gerenciado e dashboards.
3. `03-managed-istio`: configuração de service mesh com políticas mTLS.
4. `04-managed-keda`: escalonamento baseado em eventos usando Azure Service Bus.
5. `05-managed-nginx`: ingress controller NGINX (comparativo com AGIC).
6. `06-storage-volumes`: gerenciamento de volumes persistentes e snapshots (novo módulo).

Cada lab inclui:
- `README.md` com objetivos, pré-requisitos e checklist.
- `manifests/` com YAMLs versionados.
- `scripts/` com automações idempotentes.

> Execute os labs em ordem e utilize os scripts de validação em `scripts/validate/` para confirmar os resultados.
