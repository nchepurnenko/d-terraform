resource "yandex_storage_bucket" "tf-backend" {
  access_key    = yandex_iam_service_account_static_access_key.sa-terrafom-static-key.access_key
  secret_key    = yandex_iam_service_account_static_access_key.sa-terrafom-static-key.secret_key
  bucket        = "tf.jkkoaqsqcfpkmswl"
  acl           = "private"
  force_destroy = true
}
