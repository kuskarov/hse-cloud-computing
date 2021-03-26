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
  }
  package {
    bucket_name = yandex_storage_bucket.src_bucket.bucket
    object_name = yandex_storage_object.src.key
  }
}
