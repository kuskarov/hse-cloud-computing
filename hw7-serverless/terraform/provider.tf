terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  token = var.yandex_token
  cloud_id = var.yandex_cloud_id
  folder_id = var.yandex_folder_id
  zone = var.zone
}
