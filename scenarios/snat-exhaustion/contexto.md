# Contexto – SNAT Exhaustion em Serviços Pix

Em janeiro de 2025, o canal Pix da Caixa apresentou intermitência nos pagamentos instantâneos durante picos de acesso (17h às 19h). Os pods do microserviço `pix-gateway` respondiam com `504 Gateway Timeout` após 3 a 5 tentativas consecutivas. O monitoramento identificou falhas de saída para APIs externas de liquidação operadas pelo Banco Central.

O cluster afetado foi `aks-caixa-prod` (rede Azure CNI tradicional, App Gateway v2). Não houve deploy recente; o aumento de tráfego foi causado pela antecipação do 13º salário.
