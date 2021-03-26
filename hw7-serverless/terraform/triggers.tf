resource "yandex_function_trigger" "upload_trigger" {
  name        = "upload-trigger"
  folder_id   = var.yandex_folder_id
  object_storage {
    bucket_id = yandex_storage_bucket.upload_bucket.id
    create = true
  }
  function {
    id = yandex_function.validate.id
    service_account_id = yandex_iam_service_account.sa.id
  }
  depends_on = [
    yandex_function.validate
  ]
}

resource "yandex_function_trigger" "result_trigger" {
  name        = "result-trigger"
  folder_id   = var.yandex_folder_id
  object_storage {
    bucket_id = yandex_storage_bucket.results_bucket.id
    create = true
  }
  function {
    id = yandex_function.finalize.id
    service_account_id = yandex_iam_service_account.sa.id
  }
  depends_on = [
    yandex_function.finalize
  ]
}

resource "yandex_function_trigger" "mq_trigger" {
  name        = "mq-trigger"
  folder_id   = var.yandex_folder_id
  message_queue {
    queue_id = yandex_message_queue.tasks_queue.name
    service_account_id = yandex_iam_service_account.sa.id
    batch_cutoff = 1
    batch_size = 1
  }
  function {
    id = yandex_function.style_transfer.id
    service_account_id = yandex_iam_service_account.sa.id
  }
  depends_on = [
    yandex_function.style_transfer
  ]
}
