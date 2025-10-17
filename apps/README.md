# Aplicações de Exemplo

Este diretório contém aplicações utilizadas nos laboratórios para demonstrar integrações com AKS. Cada aplicação deve possuir documentação própria explicando requisitos, variáveis de ambiente e instruções de deploy.

## Estrutura atual
- `servicebus-processor`: worker Python usado no Lab 04 (KEDA + Service Bus).

## Boas práticas
- Empacotar imagens em registries aprovados (`acr<env>.azurecr.io`).
- Manter Dockerfiles atualizados com patches de segurança.
- Utilizar pipelines CI/CD para build e push automatizados.
