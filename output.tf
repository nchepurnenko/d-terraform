output "node-a_ext_ip" {
  value = ["${yandex_compute_instance.node-a.*.network_interface.0.nat_ip_address}"]
}

output "node-b_ext_ip" {
  value = ["${yandex_compute_instance.node-b.*.network_interface.0.nat_ip_address}"]
}
