import os
import time
import logging
from flask import Flask, request
from azure.servicebus import ServiceBusClient, ServiceBusMessage

app = Flask(__name__)

# Configuração do Azure Service Bus
CONNECTION_STR = os.environ.get("SERVICE_BUS_CONNECTION_STR")
QUEUE_NAME = os.environ.get("SERVICE_BUS_QUEUE_NAME")

# Configuração de logging
logging.basicConfig(level=logging.INFO)

@app.route('/')
def hello():
    return "Hello from KEDA queue processor!"

@app.route('/metrics')
def metrics():
    # Exemplo de métrica para HTTP autoscaling
    return "# HELP http_requests_total Total number of HTTP requests.\n# TYPE http_requests_total counter\nhttp_requests_total{method=\"get\",code=\"200\"} 1\n"

def process_messages():
    if not CONNECTION_STR or not QUEUE_NAME:
        logging.error("SERVICE_BUS_CONNECTION_STR or SERVICE_BUS_QUEUE_NAME not set.")
        return

    with ServiceBusClient.from_connection_string(CONNECTION_STR) as client:
        with client.get_queue_receiver(QUEUE_NAME) as receiver:
            logging.info(f"Listening for messages on queue: {QUEUE_NAME}")
            while True:
                received_msgs = receiver.receive_messages(max_messages=1, max_wait_time=5)
                if not received_msgs:
                    logging.info("No messages received. Waiting...")
                    time.sleep(1)
                    continue

                for msg in received_msgs:
                    logging.info(f"Received message: {msg.body.decode('utf-8')}")
                    # Simula processamento
                    time.sleep(2) 
                    receiver.complete_message(msg)
                    logging.info("Message processed and completed.")

if __name__ == '__main__':
    # Inicia o processamento de mensagens em uma thread separada ou como um processo em segundo plano
    # Para simplificar no contexto do lab, vamos apenas expor a rota HTTP e deixar o KEDA gerenciar o scaling
    # O processamento real seria feito por um worker que o KEDA escalaria.
    # Para este exemplo, a aplicação Flask é o próprio worker que KEDA escalará.
    # O KEDA irá monitorar a fila e escalar o número de réplicas desta aplicação.
    app.run(host='0.0.0.0', port=80)

