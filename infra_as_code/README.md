# Infraestrutura como Código (IaC)

Este diretório armazena templates Bicep/Terraform utilizados para provisionar recursos necessários ao workshop e ambientes Caixa. Organize os arquivos por ferramenta (`bicep/`, `terraform/`) e por cenário.

## Boas práticas
- Validar templates com `az deployment` ou `terraform validate` antes de subir PR.
- Incluir variáveis padrão alinhadas aos naming conventions (`aks-caixa-<env>`).
- Documentar dependências em `README` de cada subdiretório.

> Contribuições de IaC devem passar por revisão dupla (Arquitetura + Segurança).
