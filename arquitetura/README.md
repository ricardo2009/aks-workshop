# Arquitetura AKS para Ambientes Bancários de Missão Crítica

Este diretório consolida guias arquiteturais que suportam decisões de design para clusters AKS da Caixa Econômica Federal. Cada documento foi escrito em linguagem progressiva, oferecendo visão introdutória, recomendações intermediárias e práticas avançadas específicas para workloads críticos.

## Conteúdo

- `fundamentos-aks.md`: componentes principais, modelos de responsabilidade compartilhada, integrações Azure core.
- `modelos-rede.md`: comparação Kubenet x Azure CNI, design de endereçamento IP, network policies e integração com redes legadas.
- `controle-acesso.md`: identidade, RBAC, Azure AD, managed identities e mTLS.
- `alta-disponibilidade.md`: estratégias de resiliência, zonas de disponibilidade, multi-região e DRP.
- `seguranca.md`: controles de segurança, baseline zero trust, integração com Azure Policy, Defender e Key Vault.

## Como navegar

Cada arquivo contém:
1. **Objetivo** – o que o leitor deve aprender.
2. **Camadas de conhecimento** – iniciantes, intermediários, especialistas.
3. **Decisões arquiteturais** – prós e contras.
4. **Checklist Caixa** – itens mínimos para ambientes produtivos.
5. **Referências oficiais** – links para documentação Microsoft (sem reproduções integrais).

> Atualize este diretório sempre que houver mudança de política corporativa ou evolução dos serviços gerenciados do Azure.
