terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  token = var.yandex-token
  cloud_id = var.yandex-cloud-id
  folder_id = var.yandex-folder-id
  zone = var.zone
}
