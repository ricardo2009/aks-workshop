# Scripts Utilitários

Este diretório contém scripts shell e PowerShell que aceleram a preparação do ambiente, validações e troubleshooting durante o workshop.

## Estrutura

- `bootstrap-cluster.sh`: cria ou atualiza o cluster base de treinamento seguindo o checklist Caixa.
- `validate/`: scripts de verificação automática para cada laboratório e monitoração contínua (ex.: `validate-networking.sh`).
- `auditoria-rbac.sh`: relatório de roles e bindings (referência em `arquitetura/controle-acesso.md`).

> Todos os scripts seguem o padrão definido em `STYLE_GUIDE.md`: shebang explícito, `set -euo pipefail`, mensagens claras e idempotência sempre que possível.

## Como executar
```bash
chmod +x scripts/bootstrap-cluster.sh
./scripts/bootstrap-cluster.sh --environment treinamento --region brazilsouth
```

Antes de executar, exporte as variáveis necessárias (`AZ_SUBSCRIPTION_ID`, `RESOURCE_GROUP`, etc.) ou forneça-as como parâmetros.
