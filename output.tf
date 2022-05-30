output "cluster_external_v4_endpoint" {
  value = yandex_kubernetes_cluster.cluster.master.0.external_v4_endpoint
}

output "cluster_id" {
  value = yandex_kubernetes_cluster.cluster.id
}




