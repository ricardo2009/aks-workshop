# Workshop Técnico de Azure Kubernetes Service (AKS)

## 🎯 Caixa Econômica Federal – Ambientes Bancários de Missão Crítica

Este repositório contém o material oficial do workshop de 2 dias conduzido para as equipes da Caixa Econômica Federal. O foco é operar clusters AKS com alta disponibilidade, segurança, governança e troubleshooting avançado.

---

## 🧭 Visão Geral

O workshop combina teoria, demonstrações e laboratórios práticos. O conteúdo foi estruturado em módulos progressivos que cobrem os pilares essenciais:

- **Arquitetura e Fundamentos** – design seguro, redes, identidade.
- **Operação e Automação** – scripts, IaC, upgrades.
- **Observabilidade** – Azure Monitor, Prometheus, Grafana, Defender.
- **Troubleshooting** – playbooks para DNS, AGIC, storage, networking, escalonamento e upgrades.
- **Cenários Reais** – estudos de caso inspirados em incidentes bancários.

---

## 🗂️ Estrutura do Repositório

```text
aks-workshop/
├── README.md                  # Este guia
├── README_REVIEW.md           # Inventário atualizado do conteúdo
├── agenda/                    # Cronograma oficial do workshop
├── arquitetura/               # Guias arquiteturais (rede, acesso, HA, segurança)
├── apps/                      # Aplicações de apoio aos laboratórios
├── dashboards_alerts/         # Dashboards Grafana/Workbooks e alertas sugeridos
├── diagrams/                  # Diagramas Mermaid versionados
├── infra_as_code/             # Templates e orientações IaC (Bicep/Terraform)
├── labs/                      # Laboratórios hands-on (01 a 06)
├── monitoramento/             # Guia de observabilidade com Azure Monitor + Prometheus
├── observability/             # Integrações avançadas (Defender, tracing)
├── policy_compliance/         # Baseline de Azure Policy e controles de conformidade
├── scenarios/                 # Cenários reais documentados e labs de reprodução
├── scripts/                   # Automação (bootstrap, validações, auditorias)
├── slides/                    # Apresentações e materiais de apoio
└── troubleshooting/           # Playbooks detalhados por domínio técnico
```

Cada diretório possui um `README.md` explicando objetivo e forma de contribuição.

---

## 🚀 Início Rápido

### Pré-requisitos técnicos
- **Azure CLI 2.50+**
- **kubectl 1.28+**
- **Helm 3.12+**
- **jq**, **curl** e **bash**
- Permissões Azure: *Contributor* + *User Access Administrator* ou equivalente

### Setup inicial
```bash
git clone https://github.com/ricardo2009/aks-workshop.git
cd aks-workshop
./scripts/bootstrap-cluster.sh --environment treinamento --region brazilsouth
```

Após o provisionamento, execute os labs em ordem numérica e utilize os scripts de validação em `scripts/validate/`.

---

## 📅 Agenda Oficial

A agenda completa com objetivos de cada bloco está em [`agenda/agenda.md`](agenda/agenda.md). Em resumo:

- **Dia 1** – Arquitetura, redes, ingress (AGIC), storage e troubleshooting de DNS.
- **Dia 2** – Observabilidade, escalonamento (HPA/KEDA), segurança, upgrades e cenários reais.

---

## 📚 Módulos Principais

### Arquitetura
- Fundamentos AKS, modelos de rede, controle de acesso, alta disponibilidade, segurança.
- Checklists específicos para clusters `aks-caixa-<ambiente>`.

### Laboratórios
- 6 labs progressivos, incluindo criação do cluster, monitoramento gerenciado, Istio, KEDA, ingress e storage com snapshots.

### Troubleshooting
- Playbooks temáticos (`dns.md`, `agic.md`, `scaling.md`, `networking.md`, `storage.md`, `deploys_helm.md`, `upgrades.md`, `crashloopbackoff.md`, `istio.md`).
- Cada documento traz sintomas, diagnóstico, comandos reais, outputs simulados e boas práticas preventivas.

### Monitoramento e Observabilidade
- Guia completo (`monitoramento/monitoramento.md`) cobrindo Azure Monitor Managed Prometheus, Container Insights, mTLS e troubleshooting da coleta.
- Integração com Defender em `observability/defender-integrations.md`.

### Cenários Reais
- Estrutura padrão em `scenarios/` para registrar incidentes.
- Cenário `dns-latency`: loop de forwarding no CoreDNS corporativo.
- Cenário `snat-exhaustion`: saturação de portas outbound afetando serviços Pix, com lab dedicado.

---

## 🔐 Governança e Compliance
- Baseline de Azure Policy (`policy_compliance/baseline-policies.md`).
- Scripts de auditoria (`scripts/auditoria-rbac.sh`).
- Diretrizes para IaC (`infra_as_code/README.md`).

---

## ✅ Qualidade e Boas Práticas
- Todos os materiais seguem `CONTRIBUTING.md` e `STYLE_GUIDE.md`.
- Diagramas Mermaid versionados em `diagrams/`.
- Repositório preparado para gerar release `v1.0-workshop-caixa` após validação.

## 🧪 Validações Automatizadas (pré e pós-lab)
- `scripts/validate/validate-lab01.sh` – confere criação do cluster, namespaces e addons base.
- `scripts/validate/validate-lab02.sh` – verifica pipeline de monitoramento gerenciado e dashboards.
- `scripts/validate/validate-networking.sh` – monitora uso de IP, SNAT e políticas de rede.

Execute com variáveis de ambiente apropriadas, por exemplo:

```bash
CLUSTER_NAME=aks-caixa-trn RESOURCE_GROUP=rg-aks-caixa-trn ./scripts/validate/validate-networking.sh
```

Os scripts retornam mensagens opinativas para acelerar o troubleshooting durante o workshop.

---

## 🤝 Contribuições

1. Crie uma branch (`git checkout -b feature/minha-melhoria`).
2. Siga o guia de estilo e execute validações pertinentes.
3. Abra um Pull Request descrevendo o impacto no workshop.

Dúvidas ou sugestões? Abra uma [issue](https://github.com/ricardo2009/aks-workshop/issues).

---

## 📄 Licença

Este projeto está licenciado sob a [Licença MIT](LICENSE).

---

**Última atualização:** Outubro 2025 – alinhado às melhores práticas oficiais da Microsoft para AKS.
