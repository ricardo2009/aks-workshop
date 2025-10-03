# Lab 05: Ingress com NGINX Gerenciado

## Objetivo

Este laboratório tem como objetivo guiar o aluno na configuração do NGINX Ingress Controller gerenciado no Azure Kubernetes Service (AKS) e na implantação de uma aplicação web de exemplo, expondo-a externamente através de uma regra de Ingress.

## Pré-requisitos

*   Um cluster AKS provisionado com o add-on NGINX Ingress Controller habilitado (conforme Lab 01).
*   Azure CLI instalado e configurado.
*   `kubectl` instalado e configurado para acessar o cluster AKS.

## Passos de Execução

### 1. Verificar o NGINX Ingress Controller

Embora o script de criação do cluster no Lab 01 já habilite o NGINX Ingress Controller, execute este script para verificar seu status e obter o IP externo.

```bash
cd ../../labs/05-managed-nginx/scripts
bash enable-nginx-ingress.sh
```

**Saída Esperada:**

Você verá a saída confirmando que o NGINX Ingress Controller está habilitado e o IP externo do LoadBalancer associado a ele.

```
Verificando o status do add-on NGINX Ingress Controller no cluster AKS: aks-workshop-cluster...
Add-on NGINX Ingress Controller está habilitado.
Verificando os pods do NGINX Ingress Controller...
NAME                                        READY   STATUS    RESTARTS   AGE
ingress-nginx-controller-xxxxxxxxxx-xxxxx   1/1     Running   0          Xm
... (outros pods do NGINX Ingress Controller)
Obtendo o IP externo do NGINX Ingress Controller...
IP Externo do NGINX Ingress Controller: XX.XXX.XXX.XXX
Add-on NGINX Ingress Controller verificado com sucesso!
```

Anote o `EXTERNAL-IP` do NGINX Ingress Controller.

### 2. Implantar a Aplicação Web de Exemplo

Implante uma aplicação NGINX simples que será exposta através do Ingress.

```bash
cd ../../labs/05-managed-nginx/scripts
bash deploy-web-app.sh
```

**Saída Esperada:**

```
Criando o namespace nginx-app...
namespace/nginx-app created
Implantando a aplicação web de exemplo no namespace nginx-app...
deployment.apps/web-app created
service/web-app-service created
Aguardando a aplicação ser implantada...
deployment.apps/web-app condition met
Aplicação web de exemplo implantada com sucesso!
```

Verifique se os pods da aplicação estão rodando:

```bash
kubectl get pods -n nginx-app
```

**Saída Esperada (exemplo):**

```
NAME                       READY   STATUS    RESTARTS   AGE
web-app-xxxxxxxxxx-xxxxx   1/1     Running   0          2m
web-app-xxxxxxxxxx-yyyyy   1/1     Running   0          2m
```

### 3. Configurar a Regra de Ingress

Aplique a regra de Ingress que direcionará o tráfego para a aplicação web. Este exemplo usa o hostname `webapp.aks-workshop.com`.

```bash
cd ../../labs/05-managed-nginx/scripts
bash configure-ingress-rule.sh
```

**Saída Esperada:**

```
Aplicando a regra de Ingress para a aplicação web no namespace nginx-app...
ingress.networking.k8s.io/web-app-ingress created
Regra de Ingress aplicada com sucesso!
Para acessar a aplicação, obtenha o IP externo do NGINX Ingress Controller e configure seu DNS ou arquivo hosts para apontar webapp.aks-workshop.com para este IP.
IP Externo do NGINX Ingress Controller: XX.XXX.XXX.XXX
Adicione a seguinte entrada ao seu arquivo hosts (ou configure seu DNS):
XX.XXX.XXX.XXX    webapp.aks-workshop.com
```

### 4. Acessar a Aplicação via Ingress

Para acessar a aplicação, você precisará configurar o mapeamento do hostname `webapp.aks-workshop.com` para o `EXTERNAL-IP` do NGINX Ingress Controller. Você pode fazer isso de duas maneiras:

*   **Configurar seu arquivo `hosts` localmente:** Adicione a linha fornecida na saída do script (`XX.XXX.XXX.XXX    webapp.aks-workshop.com`) ao seu arquivo `hosts` (e.g., `/etc/hosts` no Linux/macOS, `C:\Windows\System32\drivers\etc\hosts` no Windows).
*   **Configurar um registro DNS:** Se você tiver um domínio, crie um registro `A` apontando `webapp.aks-workshop.com` para o `EXTERNAL-IP` do Ingress Controller.

Após configurar o mapeamento, abra um navegador e acesse `http://webapp.aks-workshop.com`. Você deverá ver a página de boas-vindas do NGINX.

## Próximos Passos

Com o NGINX Ingress configurado, você pode explorar regras de roteamento mais complexas, balanceamento de carga, terminação SSL e integração com certificados. O próximo laboratório abordará cenários de Troubleshooting Avançado.
