resource "yandex_function_trigger" "upload_trigger" {
  name        = "upload-trigger"
  folder_id   = var.yandex_folder_id
  object_storage {
    bucket_id = yandex_storage_bucket.upload_bucket.id
    create = true
  }
  function {
    id = yandex_function.style_transfer.id
    service_account_id = yandex_iam_service_account.invoker.id
  }
  depends_on = [
    yandex_function.style_transfer
  ]
}
