# Dashboards e Alertas

Este diretório reúne dashboards Grafana/Workbook e definições de alertas críticos para operação do AKS em ambientes bancários.

## Conteúdo sugerido
- `grafana/`: JSONs de dashboards (cluster overview, AGIC, KEDA, Azure CNI, Istio).
- `workbooks/`: Azure Monitor Workbooks em JSON.
- `alerts/`: ARM/Bicep/Terraform templates para regras de alerta (DNS latency, SNAT, CrashLoop, Pod quota).

## Recomendações de uso
1. Antes do workshop, importe os dashboards em um workspace Grafana gerenciado.
2. Utilize tags padrão (`CostCenter=CaixaWorkshop`) para rastrear alertas gerados.
3. Adapte thresholds para ambientes produtivos e documente decisões no arquivo correspondente.

## Próximos passos
- Adicionar dashboards específicos fornecidos pela Caixa assim que aprovados.
- Versionar alterações com histórico de autores para facilitar auditoria.
