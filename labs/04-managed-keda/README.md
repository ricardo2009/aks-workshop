# Lab 04: Autoscaling com KEDA Gerenciado

## Objetivo

Este laboratório tem como objetivo guiar o aluno na habilitação do add-on KEDA (Kubernetes Event-driven Autoscaling) gerenciado no Azure Kubernetes Service (AKS) e na configuração de uma aplicação de exemplo para escalar automaticamente com base em eventos de uma fila do Azure Service Bus.

## Pré-requisitos

*   Um cluster AKS provisionado com o add-on KEDA habilitado (conforme Lab 01).
*   Azure CLI instalado e configurado.
*   `kubectl` instalado e configurado para acessar o cluster AKS.
*   Uma fila do Azure Service Bus criada. Anote a string de conexão da política de acesso compartilhado (RootManageSharedAccessKey).

## Passos de Execução

### 1. Habilitar o Add-on KEDA (se ainda não estiver habilitado)

Embora o script de criação do cluster no Lab 01 já habilite o KEDA, você pode re-executar o script de habilitação para garantir ou caso esteja usando um cluster existente.

```bash
cd ../../labs/04-managed-keda/scripts
bash enable-keda-addon.sh
```

**Saída Esperada:**

Você verá a saída confirmando que o add-on KEDA foi habilitado e que os pods do operador KEDA estão rodando no namespace `kube-system`.

```
Habilitando o add-on KEDA no cluster AKS: aks-workshop-cluster...
... (saída da atualização do AKS)
Verificando a instalação do KEDA...
true
Verificando os pods do KEDA...
NAME                                         READY   STATUS    RESTARTS   AGE
keda-operator-xxxxxxxxxx-xxxxx               1/1     Running   0          Xm
keda-operator-metrics-apiserver-xxxxxxxxxx-yyyyy   1/1     Running   0          Xm
Add-on KEDA habilitado e verificado com sucesso!
```

### 2. Criar Secret do Kubernetes para o Azure Service Bus

O KEDA precisa acessar a string de conexão do Azure Service Bus. Crie um secret no Kubernetes com essa informação.

Substitua `YOUR_SERVICE_BUS_CONNECTION_STRING` pela string de conexão da sua fila do Azure Service Bus.

```bash
kubectl create secret generic servicebus-secret --from-literal=connectionString='YOUR_SERVICE_BUS_CONNECTION_STRING' -n keda-app
```

**Saída Esperada:**

```
secret/servicebus-secret created
```

### 3. Implantar a Aplicação de Processamento de Fila

Esta etapa irá construir a imagem Docker da aplicação de exemplo, fazer push para o ACR e implantar a aplicação no cluster AKS.

```bash
cd ../../labs/04-managed-keda/scripts
bash deploy-queue-processor.sh
```

**Saída Esperada:**

Você verá a saída da construção da imagem Docker, do push para o ACR e da implantação da aplicação no namespace `keda-app`.

```
Autenticando no Azure Container Registry: aksworkshopacrXXXXXXXXXX...
... (saída da autenticação do ACR)
Construindo a imagem Docker para a aplicação de processamento de fila...
... (saída da construção da imagem)
Fazendo push da imagem para o ACR...
... (saída do push da imagem)
Criando o namespace keda-app...
namespace/keda-app created
Implantando a aplicação de processamento de fila no namespace keda-app...
deployment.apps/keda-queue-processor created
service/keda-queue-processor-service created
Aguardando a aplicação ser implantada...
deployment.apps/keda-queue-processor condition met
Aplicação de processamento de fila implantada com sucesso!
```

Verifique se o deployment foi criado, mas note que o número de pods pode ser 0, pois o KEDA ainda não foi configurado para escalar.

```bash
kubectl get deploy -n keda-app
```

**Saída Esperada (exemplo):**

```
NAME                     READY   UP-TO-DATE   AVAILABLE   AGE
keda-queue-processor     0/0     0            0           2m
```

### 4. Configurar o ScaledObject do KEDA

Aplique o `ScaledObject` que instruirá o KEDA a monitorar a fila do Azure Service Bus e escalar a aplicação `keda-queue-processor`.

```bash
cd ../../labs/04-managed-keda/manifests
kubectl apply -f scaledobject-servicebus.yaml -n keda-app
```

**Saída Esperada:**

```
scaledobject.keda.sh/azure-servicebus-queue-scaledobject created
```

Verifique se o `ScaledObject` foi criado:

```bash
kubectl get scaledobject -n keda-app
```

**Saída Esperada (exemplo):**

```
NAME                                 SCALER TYPE          MIN   MAX   TRIGGERS   AUTHENTICATION   READY   ACTIVE   AGE
azure-servicebus-queue-scaledobject  azure-servicebus     0     10    azure-servicebus                    True    False    1m
```

### 5. Simular Carga na Fila e Observar Autoscaling

Agora, envie mensagens para a fila do Azure Service Bus para simular carga e observar o KEDA escalando a aplicação.

```bash
cd ../../labs/04-managed-keda/scripts
bash simulate-queue-load.sh 20 # Envia 20 mensagens
```

**Saída Esperada:**

Você verá as mensagens sendo enviadas. Monitore os pods da aplicação `keda-queue-processor`:

```bash
watch kubectl get pods -n keda-app
```

Você deverá observar que o número de pods da aplicação `keda-queue-processor` aumentará de 0 para um valor maior (até `maxReplicas` definido no `ScaledObject`) à medida que as mensagens são processadas, e diminuirá novamente para 0 após um período de inatividade (cooldown period).

## Próximos Passos

Com o KEDA configurado, você pode explorar diferentes tipos de triggers (HTTP, Kafka, Redis, etc.) e configurar regras de autoscaling mais complexas para suas aplicações. O próximo laboratório abordará o Ingress com NGINX Gerenciado.
