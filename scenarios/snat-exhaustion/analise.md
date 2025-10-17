# Análise

Os dados apontaram saturação de portas SNAT no Load Balancer padrão do AKS:
- Apenas 1.024 portas disponíveis para todo o node pool de produção.
- Cada pod `pix-gateway` abria múltiplas conexões HTTPS simultâneas, consumindo rapidamente as portas efêmeras.
- A ausência de erros no App Gateway e em DNS descartou as hipóteses 2 e 3.
- Logs do Azure Firewall mostraram tráfego permitido, descartando bloqueio na hipótese 4.

Conclusão: **exaustão de SNAT** causando resets/timeout nas conexões outbound.
