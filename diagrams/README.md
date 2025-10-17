# Diagramas Mermaid

Os arquivos deste diretório são diagramas Mermaid que representam fluxos críticos discutidos durante o workshop. Eles podem ser visualizados diretamente no GitHub ou renderizados com a extensão Mermaid CLI.

## Arquivos disponíveis
- `aks-high-availability.mmd`: arquitetura de alta disponibilidade com zonas e componentes gerenciados.
- `agic-flow.mmd`: fluxo de requisição do Application Gateway Ingress Controller até os pods.
- `keda-scaling.mmd`: arquitetura de escalonamento do KEDA com métricas externas.
- `observability-pipeline.mmd`: pipeline de métricas e logs com Azure Monitor e Prometheus.
- `topologia-rede.mmd`: visão de rede e tráfego leste-oeste/norte-sul.
- `snat-exhaustion.mmd`: mitigação de saturação SNAT com NAT Gateway e alertas.

## Como renderizar
```bash
npm install -g @mermaid-js/mermaid-cli
mmdc -i diagrams/aks-high-availability.mmd -o diagrams/aks-high-availability.png
```

> Mantenha os diagramas sincronizados com os conteúdos em `arquitetura/`, `monitoramento/` e `troubleshooting/`.
