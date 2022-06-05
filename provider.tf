terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.69.0"
    }
  }

  backend "s3" {}
}

provider "yandex" {
  service_account_key_file = file("../sa_terraform_auth.key")
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = "ru-central1-a"
}

data "yandex_iam_service_account" "terraform" {
  name = "terraform"
}
