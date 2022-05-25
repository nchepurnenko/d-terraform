
resource "yandex_compute_instance" "node-a" {

  count    = 2
  name     = "node-a${count.index}"
  hostname = "node-a${count.index}"
  zone     = "ru-central1-a"

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 5
  }

  boot_disk {
    initialize_params {
      image_id = "fd8ciuqfa001h8s9sa7i" # ubuntu 20.04
      size     = 15
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-a.id
    nat       = true

  }

  scheduling_policy {
    preemptible = true
  }

  metadata = {
    ssh-keys = "ubuntu:${var.public_key}"
  }

  # чтобы не перетирался hostname меняем конфиг cloud-init

  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = self.network_interface.0.nat_ip_address
    private_key = file("/home/user/.ssh/id_rsa")

  }

  provisioner "remote-exec" {
    inline = ["sudo chown -R ubuntu: /etc/cloud/"]
  }

  provisioner "file" {
    source      = "cloud.cfg"
    destination = "/etc/cloud/cloud.cfg"
  }

  provisioner "remote-exec" {
    inline = ["sudo chown -R root: /etc/cloud/"]
  }

}

resource "yandex_compute_instance" "node-b" {

  count    = 1
  name     = "node-b${count.index}"
  hostname = "node-b${count.index}"
  zone     = "ru-central1-b"

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 5
  }

  boot_disk {
    initialize_params {
      image_id = "fd8ciuqfa001h8s9sa7i" # ubuntu 20.04
      size     = 15
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-b.id
    nat       = true

  }

  scheduling_policy {
    preemptible = true
  }

  metadata = {
    ssh-keys = "ubuntu:${var.public_key}"
  }

  # чтобы не перетирался hostname меняем конфиг cloud-init

  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = self.network_interface.0.nat_ip_address
    private_key = file("/home/user/.ssh/id_rsa")

  }

  provisioner "remote-exec" {
    inline = ["sudo chown -R ubuntu: /etc/cloud/"]
  }

  provisioner "file" {
    source      = "cloud.cfg"
    destination = "/etc/cloud/cloud.cfg"
  }

  provisioner "remote-exec" {
    inline = ["sudo chown -R root: /etc/cloud/"]
  }

}




