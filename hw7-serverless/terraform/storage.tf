resource "yandex_storage_bucket" "upload_bucket" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket = "upload-bucket"
  force_destroy = true
}

resource "yandex_storage_bucket" "results_bucket" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key  
  bucket = "results-bucket"
  force_destroy = true
}

resource "yandex_storage_bucket" "src_bucket" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key  
  bucket = "src-bucket"
  force_destroy = true
}

resource "yandex_storage_object" "src" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key    
  bucket = yandex_storage_bucket.src_bucket.bucket
  key    = "src"
  source = "../src/src.zip"
}
