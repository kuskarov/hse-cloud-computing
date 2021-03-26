import boto3
from botocore.client import Config
import os

from kikimr.public.sdk.python import client as ydb
from concurrent.futures import TimeoutError

DATABASE = os.getenv('DATABASE')
YDB_ENDPOINT = os.getenv('YDB_ENDPOINT')

# generate presigned url and write DONE to DB
def handler(event, context):
    bucket_name = event['messages'][0]['details']['bucket_id']
    object_name = event['messages'][0]['details']['object_id']

    session = boto3.session.Session()
    s3 = session.client(
        service_name='s3',
        endpoint_url='https://storage.yandexcloud.net',
        aws_access_key_id=os.getenv('AWS_ACCESS_KEY_ID'),
        aws_secret_access_key=os.getenv('AWS_SECRET_ACCESS_KEY')
    )
   
    presigned_url = s3.generate_presigned_url(
        "get_object",
        Params={"Bucket": os.getenv('RESULTS_BUCKET_NAME'), "Key": object_name},
        ExpiresIn=500,
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
            UPSERT INTO tasks (task_id, status, result_url) VALUES
                ("{object_name}", "DONE", "{presigned_url}");
            """,
            commit_tx=True,
        )
