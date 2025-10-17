# Troubleshooting – Pods em CrashLoopBackOff

## Objetivo
Identificar rapidamente a causa raiz de pods em CrashLoopBackOff, minimizando impacto em sistemas bancários.

## Sintomas Comuns
- `kubectl get pods` mostra `CrashLoopBackOff` ou `ImagePullBackOff`.
- Eventos `Back-off restarting failed container`.
- Logs vazios (container falha antes de iniciar).
- `OOMKilled` ou `Error` no campo `Last State`.

## Diagnóstico Passo a Passo
1. **Descrever pod**
   ```bash
   kubectl describe pod <pod> -n <namespace>
   ```
2. **Ver logs**
   ```bash
   kubectl logs <pod> -n <namespace> --previous
   ```
3. **Validar initContainers**
   ```bash
   kubectl describe pod <pod> -n <namespace> | rg 'Init Containers' -A5
   ```
4. **Checar eventos de imagem**
   ```bash
   kubectl get events -n <namespace> --field-selector involvedObject.name=<pod>
   ```
5. **Verificar quotas e limites**
   ```bash
   kubectl describe limitrange -n <namespace>
   kubectl top pod <pod> -n <namespace>
   ```

## Linha Investigativa (kubectl + logs)
| Ordem | Comando | Objetivo | Como interpretar |
|-------|---------|----------|------------------|
| 1 | `kubectl get pod <pod> -n <namespace> -o wide` | Capturar node, reinícios e imagem. | Reinícios altos confirmam CrashLoop; `NODE` isolado indica problema específico. |
| 2 | `kubectl describe pod <pod> -n <namespace>` | Consolidar eventos e probes. | Eventos `Back-off` ou falha em initContainers aparecem ao final; verificar `Last State`. |
| 3 | `kubectl logs <pod> -n <namespace> --previous` | Obter logs da execução anterior. | Útil quando container reinicia rápido; ausência de logs sugere falha antes do entrypoint. |
| 4 | `kubectl get events -n <namespace> --field-selector involvedObject.name=<pod>` | Ver eventos cronológicos. | Falhas de imagem (HTTP 401/404) ou `FailedMount` para volumes. |
| 5 | `kubectl exec -n <namespace> <pod-debug> -- env` | Comparar variáveis com config esperada (usar pod debug). | Divergência indica ConfigMap/Secret incorreto. |
| 6 | `kubectl describe node <node>` | Investigar pressão do nó (memory/disk). | Condições `MemoryPressure`/`DiskPressure` podem matar pods. |
| 7 | `az acr repository show-tags --name <acr> --repository <image>` | Validar versão de imagem disponível. | Falhas `ImagePullBackOff` geralmente derivam de tag inexistente. |

## Ferramentas
- `kubectl`, `stern` para tail logs, Azure Monitor Container Insights.

## Exemplos de Outputs
- Falha de imagem:
  ```text
  Failed to pull image "acrprod.azurecr.io/api:v2": unauthorized: authentication required
  ```
- OOMKilled:
  ```text
  Last State: Terminated
    Reason: OOMKilled
    Exit Code: 137
  ```

## Causas Raiz Frequentes
- Credenciais ACR inválidas ou workload identity mal configurada.
- Recursos insuficientes (memory/CPU) e limites incorretos.
- Falhas em initContainer (migração de banco, download de certificados).
- Probes (liveness/readiness) muito agressivas.

## Playbook de Resolução
1. Ajustar credenciais (Secret Docker/Managed Identity) e reimplantar.
2. Revisar `requests`/`limits` conforme consumo real (ver `kubectl top`).
3. Desabilitar temporariamente probes para diagnóstico.
4. Habilitar `restartPolicy: Never` em ambiente de debug para analisar container.
5. Documentar causa e correção em `README_REVIEW.md` ou `scenarios/`.

## Boas Práticas Preventivas
- Utilizar `helm test` e pipelines com smoke tests.
- Configurar alertas de `PodRestartCount` > 5 em 5 minutos.
- Manter variações de config versionadas (ConfigMaps/Secrets) com rollback rápido.
- Usar `initContainers` leves e idempotentes.

## Labs Relacionados
- `labs/04-managed-keda` (monitorar pods worker).
- `labs/02-managed-prometheus-grafana` (dashboards de reinício).

## Referências
- [Troubleshoot pod deployment issues](https://learn.microsoft.com/azure/aks/troubleshooting)
- [Kubernetes debugging pods](https://kubernetes.io/docs/tasks/debug/debug-application/debug-pods/)
