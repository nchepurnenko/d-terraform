output "cluster_external_v4_endpoint" {
  value = yandex_kubernetes_cluster.cluster.master.0.external_v4_endpoint
}

resource "null_resource" "createJson" {
  provisioner "local-exec" {
    command     = "sleep 30; yc managed-kubernetes cluster get-credentials --id ${yandex_kubernetes_cluster.cluster.id} --external"
    interpreter = ["bash", "-c"]
  }
}



