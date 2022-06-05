resource "yandex_kubernetes_cluster" "cluster" {
  name        = "cluster"
  description = "k8s cluster for netology devops"

  network_id = yandex_vpc_network.netology.id

  master {
    regional {
      region = "ru-central1"

      location {
        zone      = yandex_vpc_subnet.subnet-a.zone
        subnet_id = yandex_vpc_subnet.subnet-a.id
      }

      location {
        zone      = yandex_vpc_subnet.subnet-b.zone
        subnet_id = yandex_vpc_subnet.subnet-b.id
      }

      location {
        zone      = yandex_vpc_subnet.subnet-c.zone
        subnet_id = yandex_vpc_subnet.subnet-c.id
      }
    }

    version   = "1.21"
    public_ip = true

    maintenance_policy {
      auto_upgrade = true

      maintenance_window {
        day        = "sunday"
        start_time = "23:00"
        duration   = "3h"
      }
    }
  }

  service_account_id      = data.yandex_iam_service_account.terraform.id
  node_service_account_id = data.yandex_iam_service_account.terraform.id

  release_channel         = "STABLE"
  network_policy_provider = "CALICO"
}

resource "yandex_kubernetes_node_group" "clusterNodes-a" {
  cluster_id  = yandex_kubernetes_cluster.cluster.id
  name        = "cluster-nodes-a"
  description = "k8s cluster for netology devops"
  version     = "1.21"

  instance_template {
    platform_id = "standard-v2"

    network_interface {
      nat        = true
      subnet_ids = [yandex_vpc_subnet.subnet-a.id]
    }

    resources {
      memory = 2
      cores  = 2
    }

    boot_disk {
      type = "network-hdd"
      size = 64
    }

    scheduling_policy {
      preemptible = true
    }

  }

  scale_policy {
    auto_scale {
      min     = 1
      max     = 2
      initial = 1
    }
  }

  allocation_policy {
    location {
      zone = "ru-central1-a"
    }
  }

  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true

    maintenance_window {
      day        = "saturday"
      start_time = "23:00"
      duration   = "3h"
    }
  }
}

resource "yandex_kubernetes_node_group" "clusterNodes-b" {
  cluster_id  = yandex_kubernetes_cluster.cluster.id
  name        = "cluster-nodes-b"
  description = "k8s cluster for netology devops"
  version     = "1.21"

  instance_template {
    platform_id = "standard-v2"

    network_interface {
      nat        = true
      subnet_ids = [yandex_vpc_subnet.subnet-b.id]
    }

    resources {
      memory = 2
      cores  = 2
    }

    boot_disk {
      type = "network-hdd"
      size = 64
    }

    scheduling_policy {
      preemptible = true
    }

  }

  scale_policy {
    auto_scale {
      min     = 1
      max     = 2
      initial = 1
    }
  }

  allocation_policy {
    location {
      zone = "ru-central1-b"
    }
  }

  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true

    maintenance_window {
      day        = "friday"
      start_time = "23:00"
      duration   = "3h"
    }
  }
}

resource "yandex_kubernetes_node_group" "clusterNodes-c" {
  cluster_id  = yandex_kubernetes_cluster.cluster.id
  name        = "cluster-nodes-c"
  description = "k8s cluster for netology devops"
  version     = "1.21"

  instance_template {
    platform_id = "standard-v2"

    network_interface {
      nat        = true
      subnet_ids = [yandex_vpc_subnet.subnet-c.id]
    }

    resources {
      memory = 2
      cores  = 2
    }

    boot_disk {
      type = "network-hdd"
      size = 64
    }

    scheduling_policy {
      preemptible = true
    }

  }

  scale_policy {
    auto_scale {
      min     = 1
      max     = 2
      initial = 1
    }
  }

  allocation_policy {
    location {
      zone = "ru-central1-c"
    }
  }

  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true

    maintenance_window {
      day        = "monday"
      start_time = "23:00"
      duration   = "3h"
    }
  }
}

resource "yandex_compute_instance" "web-server" {

  count = 1

  name     = "ws${count.index}"
  hostname = "ws${count.index}"

  resources {
    cores         = 2
    memory        = 1
    core_fraction = 5
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-c.id
  }

  boot_disk {
    initialize_params {
      image_id = "fd832gltdaeepe0m2hi8" # LAMP
      size     = 10
    }
  }

  scheduling_policy {
    preemptible = true
  }
}
