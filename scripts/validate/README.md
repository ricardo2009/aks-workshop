# Scripts de Validação Automática

Cada laboratório possui um script de verificação rápida que confirma pré-requisitos, recursos criados e métricas coletadas.

## Convenções
- Nome: `validate-<lab>.sh`.
- Entrada: nenhum parâmetro obrigatório; variáveis opcionais via env (`AKS_CLUSTER`, `RESOURCE_GROUP`).
- Saída: mensagens no formato `[PASS]`, `[WARN]`, `[FAIL]` para facilitar coleta por pipelines.

## Exemplos disponíveis
- `validate-lab01.sh`: valida criação do cluster e conectividade básica.
- `validate-lab02.sh`: verifica recursos do Azure Monitor Managed Prometheus.
- `validate-networking.sh`: acompanha capacidade de pods, saturação SNAT e Network Policies.

Execute com:
```bash
./scripts/validate/validate-lab01.sh --cluster aks-caixa-trn --resource-group rg-aks-caixa-trn

# Monitoramento contínuo da rede
./scripts/validate/validate-networking.sh
```
