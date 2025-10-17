# Troubleshooting – Escalonamento (HPA/KEDA)

## Objetivo
Garantir que workloads bancários escalem de forma previsível utilizando Horizontal Pod Autoscaler (HPA) e KEDA.

## Sintomas Comuns
- Pods não escalam apesar do aumento de carga.
- `ScaledObject` permanece em estado `NotActive`.
- Métricas personalizadas não aparecem (`kubectl get --raw "/apis/custom.metrics.k8s.io"`).
- HPA exibe `FailedGetResourceMetric`.
- Escalonamento sobe mas não retorna ao baseline (pods ficam acima do esperado).

## Diagnóstico Passo a Passo
1. **Verificar status do ScaledObject**
   ```bash
   kubectl describe scaledobject queue-processor -n pagamentos
   kubectl get scaledobject -n pagamentos
   ```
2. **Checar métricas KEDA**
   ```bash
   kubectl logs -n keda deploy/keda-operator
   kubectl logs -n keda deploy/keda-metrics-apiserver
   ```
3. **Validar credenciais externas (Service Bus, Storage, etc.)**
   ```bash
   kubectl get secret keda-servicebus -n pagamentos -o yaml
   ```
4. **Consultar métricas HPA**
   ```bash
   kubectl get hpa -n pagamentos queue-processor -o yaml
   ```
5. **Monitorar queue backlog ou métrica custom** via Azure Monitor.

## Linha Investigativa (kubectl + métricas)
| Ordem | Comando | Objetivo | Como interpretar |
|-------|---------|----------|------------------|
| 1 | `kubectl get scaledobject -n <namespace>` | Confirmar estado geral (Active/NotActive). | `NotReady`/`Error` indica falha de configuração ou credencial. |
| 2 | `kubectl describe scaledobject <nome> -n <namespace>` | Revisar condições detalhadas. | Condição `Active` com `reason=ScaledObjectCheckFailed` exige revisar trigger. |
| 3 | `kubectl logs -n keda deploy/keda-operator --tail 200` | Coletar erros do operador. | Mensagens `authentication` ou `failed to query metrics` apontam raiz. |
| 4 | `kubectl logs -n keda deploy/keda-metrics-apiserver --tail 100` | Validar exposição de métricas. | Erros `unable to fetch metrics` ou latência alta. |
| 5 | `kubectl get hpa -n <namespace> <nome>` | Ver status do HPA gerado. | `Current CPU`/`Current custom metrics` vazios indicam falha de métrica. |
| 6 | `kubectl describe hpa -n <namespace> <nome>` | Detalhar condições de escalonamento. | `FailedGetResourceMetric` ou `Missing metrics` direcionam para Prometheus/Adapter. |
| 7 | `kubectl top pod -n <namespace>` | Garantir que métricas do Metrics Server estejam fluindo. | Se falhar, verificar add-on metrics-server. |
| 8 | `az monitor metrics list --resource <recurso>` | Correlacionar backlog/métrica externa com dados do cluster. | Divergência indica problema de telemetria. |

## Ferramentas
- `kubectl`, `keda` namespace logs.
- Azure Monitor (Service Bus Metrics `ActiveMessages`).
- `dashboards_alerts/keda-overview.json`.

## Exemplos de Outputs
- `kubectl describe scaledobject`:
  ```text
  Conditions:
    AbleToScale:   True
    ScaledObjectReady: False
    Active:        False (error pulling metrics: unable to get metrics for queue)
  ```
- Log do operador:
  ```text
  Error fetching metrics from Azure Service Bus: unauthorized, check connection string
  ```

## Causas Raiz Frequentes
- Connection string inválido ou sem permissões `Listen`.
- Falta de permissões Managed Identity (quando usando Workload Identity).
- Métricas customizadas não publicadas (aplicação não expõe endpoint Prometheus).
- `cooldownPeriod` elevado impossibilitando scale-in rápido.
- Falhas na instalação do add-on KEDA gerenciado.

## Playbook de Resolução
1. Validar credenciais/identidade e atualizar Secret ou `TriggerAuthentication`.
2. Conferir se `ScaledObject` aponta para namespace/queue corretos.
3. Acompanhar backlog via `az servicebus queue show` e comparar com métrica KEDA.
4. Ajustar parâmetros (`minReplicaCount`, `cooldownPeriod`, `pollingInterval`).
5. Reiniciar pods `keda-operator` se atualização de config não refletir.

## Boas Práticas Preventivas
- Habilitar `keda_metrics_adapter_scaled_objects` em Azure Monitor.
- Realizar testes de carga controlada antes de incidentes (scripts em `labs/04-managed-keda/scripts/simulate-queue-load.sh`).
- Definir `minReplicaCount` > 0 para workloads críticos.
- Versionar `ScaledObject` e `TriggerAuthentication` em Git.

## Labs Relacionados
- `labs/04-managed-keda`.
- `agenda/agenda.md` Dia 2 – Escalonamento avançado.

## Referências
- [KEDA troubleshooting guide](https://keda.sh/docs/latest/troubleshooting/)
- [Autoscale on Azure Service Bus](https://learn.microsoft.com/azure/azure-functions/functions-bindings-service-bus-trigger#scaling)
