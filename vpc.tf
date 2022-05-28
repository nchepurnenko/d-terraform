resource "yandex_vpc_network" "netology" {}

resource "yandex_vpc_subnet" "subnet-a" {
  v4_cidr_blocks = ["192.168.10.0/24"]
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.netology.id
}

resource "yandex_vpc_subnet" "subnet-b" {
  v4_cidr_blocks = ["192.168.20.0/24"]
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.netology.id
}

resource "yandex_vpc_subnet" "subnet-c" {
  v4_cidr_blocks = ["192.168.30.0/24"]
  zone           = "ru-central1-c"
  network_id     = yandex_vpc_network.netology.id
}

