# Análise

- A hipótese 2 foi confirmada: atualização recente adicionou entrada duplicada `forward . 10.20.0.10` apontando para servidor DNS fora de operação, gerando loop.
- O alerta coincidiu com change window registrada no ITSM.
- Não houve saturação de CPU/memória; pods CoreDNS permaneceram saudáveis.
- Métrica `coredns_forward_request_duration_seconds` elevou-se apenas para destinos específicos, reforçando problema externo.
