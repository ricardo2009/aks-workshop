# Lab 01: Criação e Configuração Básica do Cluster AKS

## Objetivo

Este laboratório tem como objetivo guiar o aluno na criação de um cluster Azure Kubernetes Service (AKS) com as extensões gerenciadas essenciais (Monitoramento, NGINX Ingress Controller, KEDA e Istio) e um Azure Container Registry (ACR). Ao final, será implantada uma aplicação NGINX simples para verificar a conectividade básica do cluster.

## Pré-requisitos

*   Uma assinatura Azure ativa.
*   Azure CLI instalado e configurado.
*   `kubectl` instalado.
*   Permissões para criar recursos no Azure (Grupos de Recursos, AKS, ACR).

## Passos de Execução

### 1. Criar o Cluster AKS e ACR

Execute o script `create-aks-cluster.sh` para provisionar o grupo de recursos, o ACR e o cluster AKS. Este script já inclui a habilitação dos add-ons de monitoramento (Prometheus/Grafana), NGINX Ingress Controller, KEDA e Istio.

```bash
cd ../../labs/01-aks-cluster-creation/scripts
bash create-aks-cluster.sh
```

**Saída Esperada:**

O script levará alguns minutos para ser concluído. Você verá saídas indicando a criação do grupo de recursos, do ACR e do cluster AKS. Ao final, ele configurará automaticamente o `kubectl`.

```
Criando o grupo de recursos: aks-workshop-rg na região eastus...
... (saída da criação do grupo de recursos)
Criando o Azure Container Registry: aksworkshopacrXXXXXXXXXX...
... (saída da criação do ACR)
Criando o cluster AKS: aks-workshop-cluster com add-ons gerenciados...
... (saída da criação do cluster AKS)
Configurando kubectl para acessar o cluster AKS...
... (saída da configuração do kubectl)
Cluster AKS e ACR criados e configurados com sucesso!
```

### 2. Verificar a Configuração do kubectl

Confirme que o `kubectl` está apontando para o cluster recém-criado.

```bash
kubectl config current-context
```

**Saída Esperada:**

```
aks-workshop-rg-aks-workshop-cluster
```

### 3. Implantar uma Aplicação de Teste

Implante uma aplicação NGINX simples para verificar a conectividade básica e o funcionamento do cluster.

```bash
cd ../../labs/01-aks-cluster-creation/manifests
kubectl apply -f sample-app.yaml
```

**Saída Esperada:**

```
deployment.apps/nginx-deployment created
service/nginx-service created
```

### 4. Verificar o Status da Aplicação

Verifique se os pods do NGINX estão rodando e se o serviço LoadBalancer recebeu um IP externo.

```bash
kubectl get pods -l app=nginx
kubectl get svc nginx-service
```

**Saída Esperada (exemplo):**

```
NAME                                READY   STATUS    RESTARTS   AGE
nginx-deployment-xxxxxxxxxx-xxxxx   1/1     Running   0          2m
nginx-deployment-xxxxxxxxxx-yyyyy   1/1     Running   0          2m

NAME            TYPE           CLUSTER-IP    EXTERNAL-IP    PORT(S)        AGE
nginx-service   LoadBalancer   10.0.XX.XXX   XX.XXX.XXX.XXX   80:3XXXX/TCP   2m
```

Anote o `EXTERNAL-IP` do `nginx-service`. Pode levar alguns minutos para que o IP externo seja provisionado.

### 5. Acessar a Aplicação

Abra um navegador e acesse o `EXTERNAL-IP` obtido no passo anterior. Você deverá ver a página de boas-vindas do NGINX.

## Próximos Passos

Com o cluster AKS básico e o ACR configurados, você está pronto para explorar os próximos laboratórios, que abordarão o monitoramento, service mesh, autoscaling e ingress.
