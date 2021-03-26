resource "yandex_storage_bucket" "upload_bucket" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket = "upload-bucket2"
  force_destroy = true
}

resource "yandex_storage_bucket" "results_bucket" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key  
  bucket = "results-bucket2"
  force_destroy = true
}

resource "yandex_storage_bucket" "src_bucket" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key  
  bucket = "src-bucket2"
  force_destroy = true
}

resource "yandex_storage_object" "src" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key    
  bucket = yandex_storage_bucket.src_bucket.bucket
  key    = "src"
  source = "../style-transfer/src.zip"
}

resource "yandex_storage_object" "api" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key    
  bucket = yandex_storage_bucket.src_bucket.bucket
  key    = "api"
  source = "../api/api.zip"
}

resource "yandex_storage_object" "val" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key    
  bucket = yandex_storage_bucket.src_bucket.bucket
  key    = "val"
  source = "../validate/validate.zip"
}

resource "yandex_storage_object" "fin" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key    
  bucket = yandex_storage_bucket.src_bucket.bucket
  key    = "fin"
  source = "../finalize/fin.zip"
}
