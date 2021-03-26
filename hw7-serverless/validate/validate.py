import boto3
from botocore.client import Config
import os

from kikimr.public.sdk.python import client as ydb
from concurrent.futures import TimeoutError

DATABASE = os.getenv('DATABASE')
YDB_ENDPOINT = os.getenv('YDB_ENDPOINT')
QUEUE_URL = os.getenv('QUEUE_URL')

# just send message to YMQ
def handler(event, context):
    bucket_name = event['messages'][0]['details']['bucket_id']
    object_name = event['messages'][0]['details']['object_id']
   
    # Create client
    client = boto3.client(
        service_name='sqs',
        endpoint_url='https://message-queue.api.cloud.yandex.net',
        region_name='ru-central1'
    )

    # Send message to queue
    client.send_message(
        QueueUrl=QUEUE_URL,
        MessageBody=object_name
    )

    # write to DB

    driver_config = ydb.DriverConfig(
        YDB_ENDPOINT, DATABASE, credentials=ydb.construct_credentials_from_environ(),
        root_certificates=ydb.load_ydb_root_certificate(),
    )
    
    with ydb.Driver(driver_config) as driver:
        try:
            driver.wait(timeout=5)
        except TimeoutError:
            print("Connect failed to YDB")
            print("Last reported errors by discovery:")
            print(driver.discovery_debug_details())
            exit(1)

        session = driver.table_client.session().create()
    
        session.transaction().execute(
            f"""
            UPSERT INTO tasks (task_id, status) VALUES
                ("{object_name}", "PROCESSING");
            """,
            commit_tx=True,
        )
