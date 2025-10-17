# Hipóteses Levantadas

1. **Exaustão de portas SNAT no Azure Load Balancer** usado pelo AKS para tráfego outbound (suspeita principal).
2. Falha intermitente no DNS externo (`coredns` sem respostas para domínios do Bacen).
3. Limites na API externa (rate limit imposto pelo provedor Pix), retornando `429`.
4. Bloqueio intermitente no Azure Firewall entre sub-redes de integração.
