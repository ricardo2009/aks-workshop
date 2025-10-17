# Agenda Oficial - Workshop AKS Caixa Econômica Federal

> **Duração:** 2 dias consecutivos (8h/dia)  
> **Formato:** Blocos teóricos curtos seguidos de demonstrações e laboratórios guiados  
> **Objetivo:** Capacitar times técnicos da Caixa a operar, suportar e evoluir workloads críticos no AKS com excelência operacional.

---

## Dia 1 – Fundamentos Resilientes e Operação Base

| Horário | Módulo | Objetivos | Recursos |
|--------|--------|-----------|----------|
| 08:30 - 09:00 | Abertura e contexto | Alinhamento com visão estratégica Caixa, pilares de missão crítica, expectativas do workshop. | Slides introdutórios, briefing riscos e regulações bancárias. |
| 09:00 - 09:45 | Arquitetura AKS Missão Crítica | Revisar componentes AKS, opções de controle-plane, SLA, zonas de disponibilidade, estratégia multi-região. | `arquitetura/fundamentos-aks.md`, diagrama `diagrams/aks-high-availability.mmd`. |
| 09:45 - 10:30 | Redes no AKS (Azure CNI) | Conceitos de VNet, sub-redes, SNAT, IP exhaustion, policy enforcement. | `arquitetura/modelos-rede.md`, lab `labs/01-aks-cluster-creation`. |
| 10:30 - 10:45 | Intervalo |  |  |
| 10:45 - 12:00 | Lab 01 – Criação do Cluster Prod-Ready | Provisionar cluster `aks-caixa-trn` com Azure CNI, managed identity, Azure Monitor, auto-upgrade control-plane. | `labs/01-aks-cluster-creation/README.md`, scripts `scripts/bootstrap-cluster.sh`. |
| 12:00 - 13:00 | Almoço |  |  |
| 13:00 - 13:40 | Ingress Controller com AGIC | Funcionamento do AGIC, dependências App Gateway v2, comparativo NGINX. | `troubleshooting/agic.md`, diagrama `diagrams/agic-flow.mmd`. |
| 13:40 - 14:40 | Lab 02 – App Gateway + AGIC | Criar App Gateway, integrar ao AKS, publicar app bancário dummy com TLS e health probes. | `labs/05-managed-nginx` (adaptação AGIC), manifestos `labs/05-managed-nginx/manifests`. |
| 14:40 - 15:00 | Intervalo |  |  |
| 15:00 - 16:00 | Storage Statefull Missão Crítica | Revisar CSI Azure Disk/File, snapshots, políticas de retenção e criptografia. | `troubleshooting/storage.md`, `labs/06-storage-volumes`. |
| 16:00 - 17:30 | Troubleshooting guiado (DNS + AGIC) | Diagnóstico de falhas reais: latência CoreDNS, conflitos ingress. | `troubleshooting/dns.md`, `troubleshooting/agic.md`, cenários simulados `scenarios/dns-latency/`. |
| 17:30 - 18:00 | Debriefing Dia 1 | Revisão resultados, dúvidas, lições aprendidas. | Quadro resumo, formulário feedback. |

---

## Dia 2 – Operação Avançada, Observabilidade e Automação

| Horário | Módulo | Objetivos | Recursos |
|--------|--------|-----------|----------|
| 08:30 - 09:00 | Recap + Warm-up | Revisão checkpoints, alinhamento expectativas do dia. | Quiz rápido, `agenda/warmup.md` (opcional). |
| 09:00 - 10:00 | Observabilidade com Azure Monitor + Prometheus | Arquitetura de coleta, custo, métricas essenciais, integrações SIEM. | `monitoramento/monitoramento.md`, ConfigMaps exemplo. |
| 10:00 - 11:30 | Lab 03 – Managed Prometheus + Grafana | Ativar AMA Metrics, ajustar ConfigMaps, publicar dashboards Caixa. | `labs/02-managed-prometheus-grafana`. |
| 11:30 - 12:00 | Troubleshooting Observabilidade | Falhas de scrape, cardinalidade, autenticação TLS. | `monitoramento/monitoramento.md`, `troubleshooting/scaling.md`. |
| 12:00 - 13:00 | Almoço |  |  |
| 13:00 - 13:45 | Escalonamento avançado (HPA + KEDA) | Conceitos, métrica personalizada, autoscaling eventos. | `troubleshooting/scaling.md`, diagrama `diagrams/keda-scaling.mmd`. |
| 13:45 - 14:45 | Lab 04 – KEDA + Service Bus | Implantar processador Service Bus, simular bursts, analisar HPA. | `labs/04-managed-keda`, app `apps/servicebus-processor`. |
| 14:45 - 15:00 | Intervalo |  |  |
| 15:00 - 16:00 | Governança e Compliance | Azure Policy, Defender for Containers, baseline Caixa. | `policy_compliance/README.md`, `observability/defender-integrations.md`. |
| 16:00 - 17:00 | Troubleshooting Profundo | Playbooks CrashLoopBackOff, falhas Helm, upgrades. | `troubleshooting/crashloopbackoff.md`, `troubleshooting/deploys_helm.md`, `troubleshooting/upgrades.md`. |
| 17:00 - 17:30 | Cenários Reais Caixa | Discussão de incidentes (Pix, FGTS), documentação templates. | `scenarios/README.md`, cenários fornecidos. |
| 17:30 - 18:00 | Encerramento & Próximos Passos | Avaliação, próximos incrementos, roadmap automações. | Checklist final, `README.md`. |

---

## Requisitos de Infraestrutura para o Workshop

- Subscription com permissão de **Owner** ou **Contributor + User Access Administrator**.
- Quota para 10 vCPUs Standard_DSv3 na região primária (ex: Brazil South).
- App Gateway Standard v2, Azure Key Vault, Storage Account e Azure Monitor Log Analytics pré-provisionados ou permissão para criação.
- Acesso a repositórios internos Caixa para publicar helm charts e imagens container.

## Instrumentos de Avaliação

- Checkpoints práticos ao final de cada lab (validação automática via scripts em `scripts/validate/`).
- Quiz Kahoot ao final de cada dia (perguntas mapeadas nos módulos).
- Debriefing qualitativo com responsáveis técnicos Caixa.

## Sugestões para Instrutores

1. **Antecipe recursos**: provisionar clusters de apoio (`aks-caixa-ref`) para demonstrações rápidas em caso de instabilidades.
2. **Monitore custos**: utilizar tags `CostCenter=CaixaWorkshop` e `Environment=Training` para rastrear gastos.
3. **Faça dry-run**: executar todos os scripts e labs 48h antes para validar dependências e credenciais.
4. **Capture métricas**: use dashboards `dashboards_alerts/` para mostrar evolução em tempo real durante o treino.
5. **Documente dúvidas**: registrar perguntas recorrentes em `README_REVIEW.md` para próximas edições.

## Próximos Passos

- Atualize este arquivo quando houver mudanças no roteiro ou duração do workshop.
- Sincronize com o time de infraestrutura da Caixa para garantir disponibilidade de recursos.
- Após o workshop, gere lições aprendidas e abra issues com melhorias propostas.
