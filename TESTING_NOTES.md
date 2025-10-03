# Notas de Teste para o Workshop AKS

Esta seção é dedicada aos procedimentos e resultados dos testes para garantir a robustez e a ausência de erros nos scripts e manifestos dos laboratórios.

## Abordagem de Teste

Os testes devem ser realizados em um ambiente Azure dedicado, simulando as condições reais de um workshop. Cada script de provisionamento e manifesto de aplicação deve ser executado e verificado individualmente, e em conjunto, para garantir a interoperabilidade dos componentes.

## Procedimentos de Teste (Manual)

Para cada laboratório, siga os `README.md`s e execute os scripts na ordem especificada. Verifique as saídas esperadas e o comportamento do cluster conforme descrito. Em particular, preste atenção a:

*   **Lab 01 (Criação do Cluster):** Verifique se o cluster AKS, ACR e os add-ons (monitoring, ingress-nginx, keda, istio) são provisionados com sucesso. Confirme o acesso via `kubectl` e a implantação da aplicação de teste.
*   **Lab 02 (Monitoramento):** Confirme que o Managed Prometheus está coletando métricas e que o Managed Grafana está acessível e pode importar o dashboard de exemplo.
*   **Lab 03 (Istio):** Verifique a injeção do sidecar, a implantação da aplicação Bookinfo, a configuração do Gateway/VirtualService e o acesso externo. Teste o roteamento de tráfego.
*   **Lab 04 (KEDA):** Crie o secret do Service Bus, implante a aplicação de processamento de fila e simule carga para observar o autoscaling de 0 a N réplicas e vice-versa.
*   **Lab 05 (NGINX Ingress):** Verifique o IP externo do Ingress Controller, implante a aplicação web e configure a regra de Ingress. Teste o acesso à aplicação via hostname.
*   **Lab 06 (Troubleshooting):** Para cada cenário, tente reproduzir o problema e siga os passos de diagnóstico e solução para confirmar sua eficácia.

## Ferramentas de Verificação

*   `az CLI`: Para verificar o status dos recursos do Azure.
*   `kubectl`: Para interagir com o cluster Kubernetes, verificar pods, serviços, deployments, logs e eventos.
*   `istioctl`: Para verificar o status do Istio e mTLS.
*   Navegador web: Para acessar o Grafana e as aplicações expostas.

## Resultados dos Testes

[Preencher aqui os resultados detalhados após a execução dos testes. Ex: "Todos os scripts executados com sucesso. Aplicações implantadas e acessíveis. Autoscaling do KEDA funcionando conforme esperado. Cenários de troubleshooting validados."]

## Próximos Passos

Após a validação completa, os scripts e manifestos serão atualizados no repositório GitHub.
