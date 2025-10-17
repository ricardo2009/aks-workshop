# Solução Implementada

1. **Provisionar NAT Gateway dedicado** para a subnet `aks-prod-snet`:
   ```bash
   az network nat gateway create \
     --resource-group rg-network-prod \
     --name nat-aks-prod \
     --public-ip-addresses pip-nat-aks-prod \
     --idle-timeout 10
   az network vnet subnet update \
     --resource-group rg-network-prod \
     --vnet-name vnet-core-prod \
     --name aks-prod-snet \
     --nat-gateway nat-aks-prod
   ```
2. **Aumentar pods réplicas** do `pix-gateway` somente após confirmar estabilidade (escala progressiva).
3. **Criar alerta** em Azure Monitor para `SNATPortUtilization > 70%`.
4. **Documentar** lições e atualizar `troubleshooting/networking.md` com rotina de verificação SNAT.

Após o NAT Gateway, os timeouts cessaram imediatamente e a métrica `SNATPortUtilization` caiu para 25%.
