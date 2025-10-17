# Contexto – Latência DNS em Produção

- **Serviço impactado**: API Pix Caixa (`pix-caixa` namespace).
- **Região**: Brazil South.
- **Sintomas**: aumento da latência média de 25ms para 400ms nas chamadas internas.
- **Detectado por**: alerta `DNSLatencyHigh` em Azure Monitor (p95 > 150ms por 5 min).
- **Janela**: 12/04/2025 das 14:20 às 14:55 BRT.
