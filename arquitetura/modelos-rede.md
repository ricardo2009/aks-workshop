# Modelos de Rede no AKS

## Objetivo
Comparar Kubenet e Azure CNI sob a ótica de ambientes bancários, apresentar padrões de endereçamento, integração com redes legadas Caixa e controles de segurança.

## Analogia
> Imagine o cluster como uma agência bancária digital. A rede define quantas mesas (IPs) existem, como os clientes chegam (ingress) e como os caixas conversam com sistemas centrais (egress). Escolher o modelo errado causa filas, colisões ou até bloqueios.

## Camadas de conhecimento

### Iniciante
- **Kubenet**: atribui IPs privados aos pods usando um espaço interno do nó. Exige NAT para saída, não integra diretamente com redes existentes. Adequado para ambientes de laboratório.
- **Azure CNI**: cada pod recebe IP da VNet. Maior consumo de IPs, porém facilita comunicação com sistemas legados e políticas de rede nativas.
- **Recomendação Caixa**: adotar **Azure CNI** em todos os ambientes produtivos.

### Intermediário
- **Planejamento de IPs**:
  - Sub-rede /23 para produção (512 IPs) garantindo escala e capacidade de pods.
  - Reservar 30% para crescimento e burst.
  - Utilizar IPAM corporativo Caixa para aprovisionamento.
- **SNAT & outbound**:
  - Verificar limites de SNAT do App Gateway e Azure Firewall.
  - Considerar `Azure NAT Gateway` para workloads com alto throughput outbound.
- **Network Policies**:
  - Azure Network Policy Manager (nativa) ou Calico para ambientes que exigem egress granulado.
  - Definir políticas default deny e liberar apenas fluxos necessários.

### Avançado
- **Limites Azure CNI**:
  - 250 pods por nó padrão (dependente do SKU). Avaliar `Azure CNI Overlay` se IPs forem escassos.
  - Monitorar métricas `pod_allocated_ips` e `pod_capacity_ips` (expostos no AMA Metrics).
- **Integração com redes on-premises**:
  - ExpressRoute com peering privado.
  - Revisar MTU e Jumbo Frames para conexões críticas.
- **Network Observability**:
  - Integrar com Azure Network Watcher, Flow Logs e Packet Capture para investigação.
  - Utilizar Hubble (quando Calico) para telemetria avançada.

## Checklist Caixa
1. Sub-redes dedicadas por ambiente (`aks-prod-net`, `aks-hml-net`).
2. Network Security Groups com regras explícitas ingress/egress (não usar permissões amplas).
3. Azure Firewall como egress centralizado com regras FQDN para sistemas core.
4. DNS corporativo integrado via conditional forwarding (ver `troubleshooting/dns.md`).
5. Monitoramento de IPs livres via Azure Monitor + Alerts.
6. Documentar fluxos em `diagrams/topologia-rede.mmd`.

## Boas práticas
- Habilite `kube-proxy` em modo IPVS para clusters grandes.
- Utilize `kubectl get po -o wide` e `az network watcher show-service-tags` para validar rotas.
- Planeje ranges exclusivos para Azure Bastion, Application Gateway e demais serviços na mesma VNet.

## Referências
- [Choose the best AKS network model](https://learn.microsoft.com/azure/aks/concepts-network)
- [Azure CNI Overlay](https://learn.microsoft.com/azure/aks/azure-cni-overlay)
- [Network policy options in AKS](https://learn.microsoft.com/azure/aks/use-network-policies)
