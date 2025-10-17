# Integrações Microsoft Defender for Containers

## Objetivo
Orientar a habilitação e o consumo das funcionalidades do Defender for Containers para proteger workloads AKS da Caixa, correlacionando alertas com Azure Monitor e SIEM corporativo.

## Passos Principais
1. **Habilitar Plano**
   ```bash
   az security pricing create \
     --name KubernetesService \
     --tier Standard
   az security pricing create \
     --name ContainerRegistry \
     --tier Standard
   ```
2. **Associar Workspace Log Analytics dedicado**
   ```bash
   az security workspace-setting create \
     --name defender-aks-caixa \
     --target-workspace "/subscriptions/<SUB>/resourceGroups/rg-monitor-caixa/providers/Microsoft.OperationalInsights/workspaces/la-aks-caixa"
   ```
3. **Instalar extensão no cluster (se necessário)**
   ```bash
   az k8s-extension create \
     --name microsoft.defender \
     --cluster-type managedClusters \
     --cluster-name aks-caixa-prod \
     --resource-group rg-aks-caixa-prod
   ```

## Alertas Prioritários
- Execução de shell interativo em container privilegiado.
- Módulos kernel suspeitos (Falco-based).
- Imagens com vulnerabilidades críticas sem correção.
- Tentativas de varredura de rede lateral.

Configure rotas de alerta:
```bash
az monitor alert create \
  --name defender-runtime-critical \
  --resource-group rg-monitor-caixa \
  --scopes "/subscriptions/<SUB>/resourceGroups/rg-monitor-caixa/providers/Microsoft.OperationalInsights/workspaces/la-aks-caixa" \
  --condition "count AggregatedValue > 0" \
  --description "Alertas runtime críticos Defender" \
  --action-groups ag-noc-caixa
```

## Integração com SIEM Caixa
- Utilize `Diagnostic Settings` para enviar dados a Event Hub dedicado ao SOC.
- Mapear campos `AlertName`, `Severity`, `ResourceName` para taxonomia interna.
- Criar playbooks Logic Apps para enriquecimento (buscar owner, service tree, CMDB).

## Boas práticas
- Rodar `az aks check-acr` para validar permissões do Defender no ACR.
- Revisar inventário de vulnerabilidades semanalmente e registrar exceções aprovadas.
- Documentar tratativas no `policy_compliance/` para auditorias.

## Referências
- [Defender for Containers overview](https://learn.microsoft.com/azure/defender-for-cloud/defender-for-containers-introduction)
- [Investigate alerts](https://learn.microsoft.com/azure/defender-for-cloud/investigate-alerts)
