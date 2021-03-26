resource "yandex_function" "style_transfer" {
  name               = "style-transfer"
  runtime            = "python37"
  entrypoint         = "style-transfer.handler"
  memory             = "1024"
  execution_timeout  = "60"
  user_hash          = "value"
  environment = {
    "AWS_ACCESS_KEY_ID" = "${yandex_iam_service_account_static_access_key.sa-static-key.access_key}"
    "AWS_SECRET_ACCESS_KEY" = "${yandex_iam_service_account_static_access_key.sa-static-key.secret_key}"
    "RESULTS_BUCKET_NAME" = "${yandex_storage_bucket.results_bucket.bucket}"
    "UPLOAD_BUCKET_NAME" = "${yandex_storage_bucket.upload_bucket.bucket}"
  }
  package {
    bucket_name = yandex_storage_bucket.src_bucket.bucket
    object_name = yandex_storage_object.src.key
  }
}


resource "yandex_function" "finalize" {
  name               = "finalize"
  runtime            = "python37"
  entrypoint         = "fin.handler"
  memory             = "1024"
  execution_timeout  = "60"
  user_hash          = "value"
  environment = {
    "AWS_ACCESS_KEY_ID" = "${yandex_iam_service_account_static_access_key.sa-static-key.access_key}"
    "AWS_SECRET_ACCESS_KEY" = "${yandex_iam_service_account_static_access_key.sa-static-key.secret_key}"
    "RESULTS_BUCKET_NAME" = "${yandex_storage_bucket.results_bucket.bucket}"
    "DATABASE" = "/ru-central1/b1g6uujcj0s62n80qgvr/etn00i5mclqbjkhj5l3i"
    "YDB_ENDPOINT" = "grpcs://ydb.serverless.yandexcloud.net:2135"
    "USE_METADATA_CREDENTIALS" = "1"
  }
  package {
    bucket_name = yandex_storage_bucket.src_bucket.bucket
    object_name = yandex_storage_object.fin.key
  }
}


resource "yandex_function" "create_task" {
  name               = "create-task"
  runtime            = "python37"
  entrypoint         = "api.create_task"
  memory             = "1024"
  execution_timeout  = "60"
  user_hash          = "value"
  service_account_id = yandex_iam_service_account.sa.id
  environment = {
    "AWS_ACCESS_KEY_ID" = "${yandex_iam_service_account_static_access_key.sa-static-key.access_key}"
    "AWS_SECRET_ACCESS_KEY" = "${yandex_iam_service_account_static_access_key.sa-static-key.secret_key}"
    "UPLOAD_BUCKET_NAME" = "${yandex_storage_bucket.upload_bucket.bucket}"
    "DATABASE" = "/ru-central1/b1g6uujcj0s62n80qgvr/etn00i5mclqbjkhj5l3i"
    "YDB_ENDPOINT" = "grpcs://ydb.serverless.yandexcloud.net:2135"
    "USE_METADATA_CREDENTIALS" = "1"
  }
  package {
    bucket_name = yandex_storage_bucket.src_bucket.bucket
    object_name = yandex_storage_object.api.key
  }
}


resource "yandex_function" "list_tasks" {
  name               = "list-tasks"
  runtime            = "python37"
  entrypoint         = "api.list_tasks"
  memory             = "1024"
  execution_timeout  = "60"
  user_hash          = "value"
  service_account_id = yandex_iam_service_account.sa.id
  environment = {
    "AWS_ACCESS_KEY_ID" = "${yandex_iam_service_account_static_access_key.sa-static-key.access_key}"
    "AWS_SECRET_ACCESS_KEY" = "${yandex_iam_service_account_static_access_key.sa-static-key.secret_key}"
    "UPLOAD_BUCKET_NAME" = "${yandex_storage_bucket.upload_bucket.bucket}"
    "DATABASE" = "/ru-central1/b1g6uujcj0s62n80qgvr/etn00i5mclqbjkhj5l3i"
    "YDB_ENDPOINT" = "grpcs://ydb.serverless.yandexcloud.net:2135"
    "USE_METADATA_CREDENTIALS" = "1"
  }
  package {
    bucket_name = yandex_storage_bucket.src_bucket.bucket
    object_name = yandex_storage_object.api.key
  }
}


resource "yandex_function" "get_task" {
  name               = "get-task"
  runtime            = "python37"
  entrypoint         = "api.get_task"
  memory             = "1024"
  execution_timeout  = "60"
  user_hash          = "value"
  service_account_id = yandex_iam_service_account.sa.id
  environment = {
    "AWS_ACCESS_KEY_ID" = "${yandex_iam_service_account_static_access_key.sa-static-key.access_key}"
    "AWS_SECRET_ACCESS_KEY" = "${yandex_iam_service_account_static_access_key.sa-static-key.secret_key}"
    "UPLOAD_BUCKET_NAME" = "${yandex_storage_bucket.upload_bucket.bucket}"
    "DATABASE" = "/ru-central1/b1g6uujcj0s62n80qgvr/etn00i5mclqbjkhj5l3i"
    "YDB_ENDPOINT" = "grpcs://ydb.serverless.yandexcloud.net:2135"
    "USE_METADATA_CREDENTIALS" = "1"
  }
  package {
    bucket_name = yandex_storage_bucket.src_bucket.bucket
    object_name = yandex_storage_object.api.key
  }
}


resource "yandex_function" "validate" {
  name               = "validate"
  runtime            = "python37"
  entrypoint         = "validate.handler"
  memory             = "1024"
  execution_timeout  = "60"
  user_hash          = "value"
  service_account_id = yandex_iam_service_account.sa.id
  environment = {
    "AWS_ACCESS_KEY_ID" = "${yandex_iam_service_account_static_access_key.sa-static-key.access_key}"
    "AWS_SECRET_ACCESS_KEY" = "${yandex_iam_service_account_static_access_key.sa-static-key.secret_key}"
    "UPLOAD_BUCKET_NAME" = "${yandex_storage_bucket.upload_bucket.bucket}"
    "DATABASE" = "/ru-central1/b1g6uujcj0s62n80qgvr/etn00i5mclqbjkhj5l3i"
    "YDB_ENDPOINT" = "grpcs://ydb.serverless.yandexcloud.net:2135"
    "USE_METADATA_CREDENTIALS" = "1"
    "QUEUE_URL" = "${yandex_message_queue.tasks_queue.id}"
  }
  package {
    bucket_name = yandex_storage_bucket.src_bucket.bucket
    object_name = yandex_storage_object.val.key
  }
}
