resource "yandex_iam_service_account" "sa" {
  folder_id = var.yandex_folder_id
  name      = "sa123"
}

resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
  folder_id = var.yandex_folder_id
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa.id
  description        = "static access key for object storage"
}

resource "yandex_iam_service_account" "invoker" {
  folder_id = var.yandex_folder_id
  name      = "invoker"
}

resource "yandex_resourcemanager_folder_iam_member" "sa-invoker" {
  folder_id = var.yandex_folder_id
  role      = "serverless.functions.invoker"
  member    = "serviceAccount:${yandex_iam_service_account.invoker.id}"
}
