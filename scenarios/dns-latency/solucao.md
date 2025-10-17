# Solução Aplicada

1. Removida entrada duplicada no ConfigMap `coredns` via `kubectl edit configmap coredns -n kube-system`.
2. Aplicado `kubectl rollout restart deployment/coredns -n kube-system` para recarregar configuração.
3. Validado `dig` dentro dos pods aplicativos (`kubectl exec`) confirmando resposta < 25ms.
4. Ajustado pipeline de change para exigir `kubectl diff` e revisão dupla em configurações DNS.
5. Criado alerta preventivo para detectar mensagens `loop detected` nos logs.
