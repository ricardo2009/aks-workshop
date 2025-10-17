> [!NOTE]
> This is a placeholder for the full content. The final version will be more detailed.

# Cenário de Troubleshooting: Problemas com Volumes Persistentes

**Nível:** Intermediário
**Duração:** 45 minutos

---

## 🎯 Objetivo

Diagnosticar e resolver problemas com **Volumes Persistentes (PVs)** e **Persistent Volume Claims (PVCs)** no AKS, incluindo falhas de montagem e provisionamento.

---

## 🚨 Sintomas Comuns

- **Pods em `Pending`:** O pod não consegue iniciar porque o PVC não pode ser satisfeito.
- **Eventos de `FailedAttachVolume` ou `FailedMount`:** Erros nos eventos do pod indicando falha ao anexar ou montar o volume.
- **PVCs em `Pending`:** O PVC não consegue encontrar um PV adequado ou a `StorageClass` não consegue provisionar um.

---

## 🛠️ Playbook de Diagnóstico

1.  **Descreva o Pod:** `kubectl describe pod <NOME-DO-POD>` (Verifique os eventos)
2.  **Descreva o PVC:** `kubectl describe pvc <NOME-DO-PVC>` (Verifique os eventos e o status)
3.  **Verifique a `StorageClass`:** `kubectl get storageclass` (Garanta que a `StorageClass` existe e está configurada corretamente)

---

## 🧪 Lab Prático

1.  **Criar um PVC com uma `StorageClass` inexistente.**
2.  **Observar que o PVC fica em estado `Pending`.**
3.  **Corrigir a `StorageClass` no manifesto do PVC e reaplicar.**

---

## 📚 Referências

- [1] **Microsoft Learn:** [Troubleshoot storage issues in AKS](https://learn.microsoft.com/azure/aks/storage-troubleshooting)

