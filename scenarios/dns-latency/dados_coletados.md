# Dados Coletados

```bash
kubectl get pods -n kube-system -l k8s-app=kube-dns
kubectl logs -n kube-system deploy/coredns --tail 50
kubectl get configmap coredns -n kube-system -o yaml
kubectl exec -n kube-system deploy/coredns -- dig api.pix.caixa.svc.cluster.local
kubectl top pod -n kube-system | grep coredns
```

### Outputs relevantes
- `kubectl logs` apresentou mensagem `forwarding loop detected`.
- `kubectl top pod` indicou uso de CPU em 30% (não saturação).
- ConfigMap `coredns` incluía bloco `forward` duplicado para `10.20.0.10` (resolver legado desativado).
- Azure Monitor apresentou spike em `kubedns_dns_request_duration_seconds` p95 380ms.
