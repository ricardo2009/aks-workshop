# Workshop Técnico de Azure Kubernetes Service (AKS)

## 🎯 Para Caixa Econômica Federal - Ambientes Bancários Missão Crítica

Bem-vindo ao workshop técnico hands-on de **Azure Kubernetes Service (AKS)** desenvolvido especificamente para ambientes bancários de missão crítica, com foco em **alta disponibilidade**, **conformidade**, **segurança** e **observabilidade avançada**.

Este repositório contém o material completo para um **workshop técnico de 2 dias**, cobrindo desde fundamentos até troubleshooting avançado, com cenários práticos e reproduzíveis.

---

## 📚 Visão Geral

O workshop está estruturado em módulos progressivos que cobrem todos os aspectos críticos para operação de AKS em ambientes bancários:

### **Dia 1: Fundamentos e Infraestrutura**
- Arquitetura do AKS e componentes principais
- Modelos de rede (Kubenet vs Azure CNI)
- Controle de acesso (RBAC, AAD, Managed Identity)
- Deploy de aplicações e storage
- Networking avançado (AGIC, NGINX Ingress)

### **Dia 2: Operação e Troubleshooting**
- Escalonamento (HPA, VPA, KEDA)
- Monitoramento e observabilidade (Prometheus, Grafana, Azure Monitor)
- Segurança e compliance
- Troubleshooting avançado com cenários reais
- Service Mesh com Istio

---

## 🗂️ Estrutura do Repositório

```
aks-workshop/
├── agenda/                      # Agenda detalhada do workshop (2 dias)
├── arquitetura/                 # Documentação arquitetural e fundamentos
├── labs/                        # Laboratórios hands-on práticos
├── troubleshooting/             # Cenários de troubleshooting detalhados
├── monitoramento/               # Monitoramento, métricas e observabilidade
├── diagrams/                    # Diagramas Mermaid de arquitetura e fluxos
├── dashboards-alerts/           # Dashboards Grafana e alertas prontos
├── scripts/                     # Scripts utilitários e automação
├── policy-compliance/           # Políticas Azure e compliance
├── observability/               # Observabilidade avançada
├── scenarios/                   # Cenários reais (template)
└── apps/                        # Aplicações de exemplo
```

---

## 🚀 Início Rápido

### Pré-requisitos

Antes de iniciar o workshop, certifique-se de ter:

- **Assinatura Azure ativa** com permissões de Contributor
- **Azure CLI** instalado (versão 2.50+)
  ```bash
  az --version
  ```
- **kubectl** instalado (versão 1.28+)
  ```bash
  kubectl version --client
  ```
- **Helm** instalado (versão 3.12+)
  ```bash
  helm version
  ```
- **Git** instalado
  ```bash
  git --version
  ```

### Clone o Repositório

```bash
git clone https://github.com/ricardo2009/aks-workshop.git
cd aks-workshop
```

### Autentique-se no Azure

```bash
az login
az account set --subscription "<SUBSCRIPTION-ID>"
```

### Execute o Setup Inicial

```bash
bash scripts/setup-environment.sh
```

---

## 📖 Módulos do Workshop

### 🏗️ [Arquitetura e Fundamentos](arquitetura/)

Compreenda a arquitetura do AKS, componentes principais, modelos de rede, controle de acesso e best practices para ambientes de missão crítica.

- [Fundamentos do AKS](arquitetura/fundamentos-aks.md)
- [Modelos de Rede](arquitetura/modelos-rede.md)
- [Controle de Acesso](arquitetura/controle-acesso.md)
- [Alta Disponibilidade](arquitetura/alta-disponibilidade.md)
- [Segurança](arquitetura/seguranca.md)

### 🧪 [Laboratórios Hands-on](labs/)

Laboratórios práticos sequenciais para construir conhecimento progressivamente:

1. **[Criação e Configuração do Cluster AKS](labs/01-aks-cluster-creation/)** - Provisione um cluster AKS com add-ons gerenciados
2. **[Monitoramento com Prometheus e Grafana](labs/02-managed-prometheus-grafana/)** - Configure observabilidade completa
3. **[Service Mesh com Istio](labs/03-managed-istio/)** - Implemente mTLS, roteamento e observabilidade
4. **[Autoscaling com KEDA](labs/04-managed-keda/)** - Configure escalonamento baseado em eventos
5. **[Ingress com NGINX](labs/05-managed-nginx/)** - Configure roteamento de tráfego externo
6. **[Storage e Volumes Persistentes](labs/06-storage-volumes/)** - Gerencie armazenamento persistente

### 🔧 [Troubleshooting Avançado](troubleshooting/)

Cenários detalhados de troubleshooting com sintomas, diagnóstico, comandos e soluções:

- [Falhas de DNS Interno (CoreDNS)](troubleshooting/dns.md)
- [Problemas com AGIC](troubleshooting/agic.md)
- [KEDA não escalando](troubleshooting/scaling.md)
- [Conectividade Azure CNI](troubleshooting/networking.md)
- [Volumes Persistentes](troubleshooting/storage.md)
- [Deploys com Helm](troubleshooting/deploys-helm.md)
- [Upgrades de Cluster](troubleshooting/upgrades.md)
- [Pods em CrashLoopBackOff](troubleshooting/crashloopbackoff.md)
- [Istio mTLS e Routing](troubleshooting/istio.md)
- [Azure Key Vault Integration](troubleshooting/keyvault.md)

### 📊 [Monitoramento e Observabilidade](monitoramento/)

Configuração completa de monitoramento para ambientes de produção:

- [Guia Completo de Monitoramento](monitoramento/monitoramento.md)
- [ConfigMaps do Azure Monitor](monitoramento/configmaps/)
- [Métricas Cruciais para Bancos](monitoramento/metricas-cruciais.md)
- [Troubleshooting de Observabilidade](monitoramento/troubleshooting-observabilidade.md)

### 📈 [Dashboards e Alertas](dashboards-alerts/)

Dashboards Grafana e alertas prontos para uso:

- **Dashboards:** Cluster Overview, NGINX Ingress, Istio, KEDA, Azure CNI
- **Alertas:** High CPU/Memory, Pod Restart Loop, DNS Latency, IP Exhaustion, Backend Health

### 🎨 [Diagramas](diagrams/)

Diagramas Mermaid de arquitetura e fluxos:

- Fluxo Ingress → Pod
- Escalonamento KEDA
- Pipeline de Métricas/Logs
- Fluxo AGIC + Application Gateway
- Topologia de Rede
- Autenticação AAD
- mTLS do Istio

### 🛡️ [Policy e Compliance](policy-compliance/)

Políticas Azure e checklist de conformidade para ambientes regulados:

- Azure Policy Examples
- Pod Security Standards
- Network Policies
- Compliance Checklist

---

## 🎓 Agenda do Workshop

### **[Dia 1: Fundamentos e Infraestrutura](agenda/agenda-dia-1.md)**

**09:00 - 12:30** - Fundamentos, Arquitetura, Networking  
**14:00 - 17:30** - Labs práticos (Cluster, Ingress, Storage)

### **[Dia 2: Operação e Troubleshooting](agenda/agenda-dia-2.md)**

**09:00 - 12:30** - Escalonamento, Observabilidade, Service Mesh  
**14:00 - 17:30** - Troubleshooting avançado e cenários reais

---

## 🎯 Público-Alvo

Este workshop é destinado a:

- **Engenheiros de Plataforma** responsáveis por AKS
- **Arquitetos de Soluções** desenhando infraestrutura Kubernetes
- **DevOps Engineers** operando clusters AKS
- **SREs** garantindo confiabilidade de sistemas
- **Engenheiros de Segurança** implementando controles de segurança

**Nível:** Intermediário a Avançado (conhecimento básico de Kubernetes é recomendado)

---

## 🔑 Diferenciais

### ✅ Foco em Ambientes Bancários
Conteúdo específico para ambientes de missão crítica com requisitos rigorosos de disponibilidade, segurança e conformidade.

### ✅ Troubleshooting Profundo
Cada cenário inclui sintomas, causas raiz, comandos de diagnóstico, outputs esperados e playbooks de resolução.

### ✅ Diagramas Visuais
Todos os fluxos críticos são ilustrados com diagramas Mermaid para facilitar o entendimento.

### ✅ Labs Reproduzíveis
Todos os labs incluem scripts, manifestos e instruções passo a passo testadas.

### ✅ Monitoramento Completo
ConfigMaps, dashboards e alertas prontos para uso em produção.

### ✅ Best Practices
Baseado em documentação oficial da Microsoft e experiências de produção.

---

## 🤝 Contribuindo

Contribuições são bem-vindas! Veja nosso [Guia de Contribuição](CONTRIBUTING.md) e [Guia de Estilo](STYLE_GUIDE.md) para detalhes.

### Como Contribuir

1. Fork o repositório
2. Crie uma branch para sua feature (`git checkout -b feature/nova-feature`)
3. Commit suas alterações (`git commit -m 'feat: adiciona nova feature'`)
4. Push para a branch (`git push origin feature/nova-feature`)
5. Abra um Pull Request

---

## 📄 Licença

Este projeto está licenciado sob a **Licença MIT**. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

---

## 📞 Suporte

Para dúvidas, problemas ou sugestões:

- Abra uma **[Issue](https://github.com/ricardo2009/aks-workshop/issues)** no GitHub
- Consulte a **[Documentação Oficial do AKS](https://learn.microsoft.com/azure/aks/)**

---

## 🔗 Recursos Adicionais

### Documentação Oficial
- [Azure Kubernetes Service (AKS)](https://learn.microsoft.com/azure/aks/)
- [AKS Best Practices](https://learn.microsoft.com/azure/aks/best-practices)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Azure Architecture Center](https://learn.microsoft.com/azure/architecture/)

### Ferramentas
- [Azure CLI](https://learn.microsoft.com/cli/azure/)
- [kubectl](https://kubernetes.io/docs/reference/kubectl/)
- [Helm](https://helm.sh/)
- [Istio](https://istio.io/)
- [KEDA](https://keda.sh/)

### Comunidade
- [AKS GitHub](https://github.com/Azure/AKS)
- [Azure Community](https://techcommunity.microsoft.com/t5/azure/ct-p/Azure)
- [Kubernetes Slack](https://kubernetes.slack.com/)

---

## ⭐ Agradecimentos

Este workshop foi desenvolvido para a **Caixa Econômica Federal** com foco em excelência técnica e aplicabilidade prática em ambientes bancários de missão crítica.

**Versão:** 1.0  
**Última atualização:** Outubro 2025

---

**Pronto para começar?** Acesse a [Agenda do Dia 1](agenda/agenda-dia-1.md) e inicie sua jornada no AKS! 🚀

