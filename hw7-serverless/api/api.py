# coding=utf-8

import boto3
from botocore.client import Config
import os
import uuid
import json

from kikimr.public.sdk.python import client as ydb
from concurrent.futures import TimeoutError


DATABASE = os.getenv('DATABASE')
YDB_ENDPOINT = os.getenv('YDB_ENDPOINT')


# generate presigned url, write to database
def create_task(event, context):
    print(event)

    task_id = str(uuid.uuid4())

    session = boto3.Session(
        aws_access_key_id=os.getenv('AWS_ACCESS_KEY_ID'),
        aws_secret_access_key=os.getenv('AWS_SECRET_ACCESS_KEY'),
        region_name="ru-central1",
    )

    s3 = session.client(
        "s3", endpoint_url="https://storage.yandexcloud.net", config=Config(signature_version="s3v4")
    )
    
    presigned_url = s3.generate_presigned_url(
        "put_object",
        Params={"Bucket": os.getenv('UPLOAD_BUCKET_NAME'), "Key": task_id},
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
            UPSERT INTO tasks (task_id, status) VALUES
                ("{task_id}", "NEW");
            """,
            commit_tx=True,
        )

        return {
                'statusCode': 200,
                'body': json.dumps({"presigned_url" : presigned_url}),
            }


# select * from database, return json
def list_tasks(event, context):
    print(event)

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

        result_sets = session.transaction(ydb.SerializableReadWrite()).execute(
            f"""
            SELECT
                task_id,
                status
            FROM tasks;
            """,
            commit_tx=True,
        )

        result = {}

        for row in result_sets[0].rows:
            task_id = row.task_id.decode("utf-8")
            status = row.status.decode("utf-8")
            result[task_id] = status

        return {
            'statusCode': 200,
            'body': json.dumps(result),
        }


# select one task from database, return json with url if task is DONE
def get_task(event, context):
    print(event)

    task_id = event['params']['task_id']

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

        result_sets = session.transaction(ydb.SerializableReadWrite()).execute(
            f"""
            SELECT
                task_id,
                status,
                result_url
            FROM tasks
            WHERE task_id = "{task_id}";
            """,
            commit_tx=True,
        )

        body = None
        if result_sets[0].rows[0].status.decode("utf-8") == "DONE":
            body = { "task_id" : result_sets[0].rows[0].task_id.decode("utf-8"), "status" : result_sets[0].rows[0].status.decode("utf-8"), "result_url" : result_sets[0].rows[0].result_url.decode("utf-8") }
        else:
            body = { "task_id" : result_sets[0].rows[0].task_id.decode("utf-8"), "status" : result_sets[0].rows[0].status.decode("utf-8")}
        
        return {
            'statusCode': 200,
            'body': json.dumps(body),
        }
