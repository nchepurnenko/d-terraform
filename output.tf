output "bastion" {
  value = ["${yandex_compute_instance.bastion.*.network_interface.0.nat_ip_address}"]
}
