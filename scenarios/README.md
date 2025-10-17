# Cenários Reais

Este diretório receberá incidentes reais e simulados fornecidos pela Caixa. Cada cenário deve seguir o template:

```
/scenarios/<nome-do-cenario>/
  contexto.md
  hipoteses.md
  dados_coletados.md
  analise.md
  solucao.md
  lab_reproducao/
```

## Cenários Disponíveis
- [`dns-latency`](dns-latency) – Falha de forwarding no CoreDNS corporativo.
- [`snat-exhaustion`](snat-exhaustion) – Saturação de portas outbound afetando serviços Pix.

## Como contribuir
1. Crie um diretório com nome descritivo (ex: `dns-latency`).
2. Preencha cada arquivo com informações objetivas, timestamps e comandos executados.
3. Caso exista laboratório reprodutível, inclua YAMLs e scripts em `lab_reproducao/`.
4. Referencie o cenário nas agendas e módulos relevantes.

> Informações sensíveis devem ser mascaradas antes do versionamento.
