resource "yandex_function" "style_transfer" {
  name               = "style-transfer"
  runtime            = "python37"
  entrypoint         = "style-transfer.handler"
  memory             = "128"
  execution_timeout  = "60"
  user_hash          = "value"
  package {
    bucket_name = yandex_storage_bucket.src_bucket.bucket
    object_name = yandex_storage_object.src.key
  }
}
