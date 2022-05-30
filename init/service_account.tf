// Create SA
resource "yandex_iam_service_account" "sa-terraform" {
  folder_id = var.folder_id
  name      = "terraform"
}

// Grant permissions
resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
  folder_id = var.folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa-terraform.id}"
}

// Create Static Access Keys and output in files
resource "yandex_iam_service_account_static_access_key" "sa-terrafom-static-key" {
  service_account_id = yandex_iam_service_account.sa-terraform.id
  description        = "static access key for object storage"
}

// Create auth key json
resource "null_resource" "createJson" {
  provisioner "local-exec" {
    command     = "sleep 30; yc iam key create --service-account-name terraform -o ../sa_terraform_auth.key"
    interpreter = ["bash", "-c"]
  }
}


