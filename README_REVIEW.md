# Inventário do Repositório – AKS Workshop Caixa

Este documento lista os diretórios e materiais principais após a reestruturação.

| Diretório | Descrição | Destaques |
|-----------|-----------|-----------|
| `agenda/` | Agenda oficial do workshop e orientações para instrutores. | `agenda.md` com cronograma 2 dias. |
| `arquitetura/` | Guias arquiteturais (fundamentos, rede, acesso, HA, segurança). | Conteúdo progressivo com checklists Caixa. |
| `apps/` | Aplicações de suporte aos labs. | `servicebus-processor` para KEDA. |
| `dashboards_alerts/` | Dashboards Grafana/Workbooks e templates de alertas. | README descreve organização. |
| `diagrams/` | Diagramas Mermaid versionados. | Fluxos AGIC, KEDA, observabilidade. |
| `infra_as_code/` | Templates IaC (placeholder). | README com boas práticas. |
| `labs/` | Laboratórios hands-on 01–06. | Lab 06 cobre storage com snapshots e cleanup. |
| `monitoramento/` | Guia completo de observabilidade. | `monitoramento.md` com pipeline AMA + Prometheus. |
| `observability/` | Integrações avançadas (Defender, tracing). | `defender-integrations.md`. |
| `policy_compliance/` | Baseline de Azure Policy e compliance. | `baseline-policies.md`. |
| `scenarios/` | Cenários reais e labs de reprodução. | `dns-latency` + `snat-exhaustion` documentados. |
| `scripts/` | Automação e validações. | `bootstrap-cluster.sh`, scripts de auditoria e validação. |
| `slides/` | Espaço para apresentações. | Estrutura sugerida dia 1/2. |
| `troubleshooting/` | Playbooks temáticos (DNS, AGIC, scaling, networking, storage, upgrades, etc.). | Linha investigativa com comandos `kubectl`/`az`. |

> Atualize esta tabela quando novos módulos forem adicionados ou removidos.
