# Lab 03: Service Mesh com Istio Gerenciado

## Objetivo

Este laboratório tem como objetivo guiar o aluno na habilitação do add-on Istio gerenciado no Azure Kubernetes Service (AKS) e na implantação de uma aplicação de exemplo (Bookinfo) para demonstrar as capacidades do service mesh, como mTLS, roteamento de tráfego e observabilidade.

## Pré-requisitos

*   Um cluster AKS provisionado com o add-on Istio habilitado (conforme Lab 01).
*   Azure CLI instalado e configurado.
*   `kubectl` instalado e configurado para acessar o cluster AKS.

## Passos de Execução

### 1. Habilitar o Add-on Istio (se ainda não estiver habilitado)

Embora o script de criação do cluster no Lab 01 já habilite o Istio, você pode re-executar o script de habilitação para garantir ou caso esteja usando um cluster existente.

```bash
cd ../../labs/03-managed-istio/scripts
bash enable-istio-addon.sh
```

**Saída Esperada:**

Você verá a saída confirmando que o add-on Istio foi habilitado e que os pods do `istiod` estão rodando no namespace `aks-istio-system`.

```
Habilitando o add-on Istio no cluster AKS: aks-workshop-cluster...
... (saída da habilitação do Istio)
Verificando a instalação do Istio...
"Istio"
Verificando os pods do Istio...
NAME                               READY   STATUS    RESTARTS   AGE
istiod-asm-X-Y-xxxxxxxxxx-xxxxx   1/1     Running   0          Xm
... (outros pods do Istio)
Add-on Istio habilitado e verificado com sucesso!
```

### 2. Implantar a Aplicação Bookinfo

Esta etapa irá criar o namespace `bookinfo`, habilitar a injeção automática de sidecar do Istio e implantar os microserviços da aplicação Bookinfo.

```bash
cd ../../labs/03-managed-istio/scripts
bash deploy-bookinfo-app.sh
```

**Saída Esperada:**

```
Criando o namespace bookinfo...
namespace/bookinfo created
Habilitando a injeção automática de sidecar do Istio no namespace bookinfo...
namespace/bookinfo labeled
Implantando a aplicação Bookinfo no namespace bookinfo...
service/details created
serviceaccount/bookinfo-details created
deployment.apps/details-v1 created
service/ratings created
serviceaccount/bookinfo-ratings created
deployment.apps/ratings-v1 created
service/reviews created
serviceaccount/bookinfo-reviews created
deployment.apps/reviews-v1 created
deployment.apps/reviews-v2 created
deployment.apps/reviews-v3 created
service/productpage created
serviceaccount/bookinfo-productpage created
deployment.apps/productpage-v1 created
Aguardando a aplicação Bookinfo ser implantada...
deployment.apps/details-v1 condition met
deployment.apps/ratings-v1 condition met
deployment.apps/productpage-v1 condition met
deployment.apps/reviews-v1 condition met
deployment.apps/reviews-v2 condition met
deployment.apps/reviews-v3 condition met
Aplicação Bookinfo implantada com sucesso!
```

Verifique se todos os pods estão rodando e se os sidecars do Istio foram injetados:

```bash
kubectl get pods -n bookinfo
```

**Saída Esperada (exemplo):**

```
NAME                             READY   STATUS    RESTARTS   AGE
details-v1-xxxxxxxxxx-xxxxx      2/2     Running   0          2m
productpage-v1-xxxxxxxxxx-yyyyy  2/2     Running   0          2m
ratings-v1-xxxxxxxxxx-zzzzz      2/2     Running   0          2m
reviews-v1-xxxxxxxxxx-aaaaa      2/2     Running   0          2m
reviews-v2-xxxxxxxxxx-bbbbb      2/2     Running   0          2m
reviews-v3-xxxxxxxxxx-ccccc      2/2     Running   0          2m
```

Note que a coluna `READY` mostra `2/2`, indicando que o contêiner da aplicação e o sidecar do Istio estão rodando.

### 3. Configurar o Istio Gateway e VirtualService

Implante o Gateway e o VirtualService para expor a aplicação Bookinfo externamente.

```bash
cd ../../labs/03-managed-istio/scripts
bash configure-istio-gateway.sh
```

**Saída Esperada:**

```
Aplicando Gateway e VirtualService do Istio para a aplicação Bookinfo no namespace bookinfo...
gateway.networking.istio.io/bookinfo-gateway created
virtualservice.networking.istio.io/bookinfo created
Aplicando DestinationRules do Istio para a aplicação Bookinfo no namespace bookinfo...
destinationrule.networking.istio.io/productpage created
destinationrule.networking.istio.io/reviews created
destinationrule.networking.istio.io/ratings created
destinationrule.networking.istio.io/details created
Configuração do Gateway e VirtualService do Istio aplicada com sucesso!
Para acessar a aplicação, obtenha o IP externo do Istio Ingress Gateway:
NAME                   TYPE           CLUSTER-IP     EXTERNAL-IP    PORT(S)                                      AGE
istio-ingressgateway   LoadBalancer   10.0.XXX.XXX   XX.XXX.XXX.XXX   15021:3XXXX/TCP,80:3XXXX/TCP,443:3XXXX/TCP   Xm
```

Anote o `EXTERNAL-IP` do `istio-ingressgateway`.

### 4. Acessar a Aplicação Bookinfo

Abra um navegador e acesse `http://EXTERNAL-IP/productpage` (substitua `EXTERNAL-IP` pelo IP obtido no passo anterior). Você deverá ver a página do produto Bookinfo.

### 5. Verificação de mTLS e Roteamento

Para verificar o mTLS, você pode usar o `istioctl` (que pode ser instalado localmente ou via pod temporário no cluster) para verificar a política de autenticação:

```bash
# Exemplo de verificação de mTLS (requer istioctl)
# istioctl authn tls-check $(kubectl get pods -l app=productpage -n bookinfo -o jsonpath='{.items[0].metadata.name}')
```

Para verificar o roteamento, atualize a página do Bookinfo várias vezes. Você notará que as avaliações (reviews) mudam entre as versões (estrelas pretas, estrelas vermelhas, sem estrelas), demonstrando o roteamento padrão do Istio entre as versões do serviço `reviews`.

## Próximos Passos

Com o Istio configurado, você pode explorar funcionalidades avançadas como injeção de falhas, políticas de tráfego mais complexas e observabilidade detalhada através do Kiali (se instalado) ou do Azure Monitor. O próximo laboratório abordará o autoscaling com KEDA.
