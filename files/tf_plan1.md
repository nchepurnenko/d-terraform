```js
$ terraform plan -var-file=.tfvars

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with
the following symbols:
  + create

Terraform will perform the following actions:

  # null_resource.createJson will be created
  + resource "null_resource" "createJson" {
      + id = (known after apply)
    }

  # yandex_kubernetes_cluster.cluster will be created
  + resource "yandex_kubernetes_cluster" "cluster" {
      + cluster_ipv4_range       = (known after apply)
      + cluster_ipv6_range       = (known after apply)
      + created_at               = (known after apply)
      + description              = "k8s cluster for netology devops"
      + folder_id                = (known after apply)
      + health                   = (known after apply)
      + id                       = (known after apply)
      + labels                   = (known after apply)
      + log_group_id             = (known after apply)
      + name                     = "cluster"
      + network_id               = (known after apply)
      + network_policy_provider  = "CALICO"
      + node_ipv4_cidr_mask_size = 24
      + node_service_account_id  = "aje51pivh5q1f82biige"
      + release_channel          = "STABLE"
      + service_account_id       = "aje51pivh5q1f82biige"
      + service_ipv4_range       = (known after apply)
      + service_ipv6_range       = (known after apply)
      + status                   = (known after apply)

      + master {
          + cluster_ca_certificate = (known after apply)
          + external_v4_address    = (known after apply)
          + external_v4_endpoint   = (known after apply)
          + internal_v4_address    = (known after apply)
          + internal_v4_endpoint   = (known after apply)
          + public_ip              = true
          + version                = "1.21"
          + version_info           = (known after apply)

          + maintenance_policy {
              + auto_upgrade = true

              + maintenance_window {
                  + day        = "sunday"
                  + duration   = "3h"
                  + start_time = "23:00"
                }
            }

          + regional {
              + region = "ru-central1"

              + location {
                  + subnet_id = (known after apply)
                  + zone      = "ru-central1-a"
                }
              + location {
                  + subnet_id = (known after apply)
                  + zone      = "ru-central1-b"
                }
              + location {
                  + subnet_id = (known after apply)
                  + zone      = "ru-central1-c"
                }
            }

          + zonal {
              + subnet_id = (known after apply)
              + zone      = (known after apply)
            }
        }
    }

  # yandex_kubernetes_node_group.clusterNodes-a will be created
  + resource "yandex_kubernetes_node_group" "clusterNodes-a" {
      + cluster_id        = (known after apply)
      + created_at        = (known after apply)
      + description       = "k8s cluster for netology devops"
      + id                = (known after apply)
      + instance_group_id = (known after apply)
      + labels            = (known after apply)
      + name              = "cluster-nodes-a"
      + status            = (known after apply)
      + version           = "1.21"
      + version_info      = (known after apply)

      + allocation_policy {
          + location {
              + subnet_id = (known after apply)
              + zone      = "ru-central1-a"
            }
        }

      + deploy_policy {
          + max_expansion   = (known after apply)
          + max_unavailable = (known after apply)
        }

      + instance_template {
          + metadata                  = (known after apply)
          + nat                       = (known after apply)
          + network_acceleration_type = (known after apply)
          + platform_id               = "standard-v2"

          + boot_disk {
              + size = 64
              + type = "network-hdd"
            }

          + network_interface {
              + ipv4       = true
              + ipv6       = (known after apply)
              + nat        = true
              + subnet_ids = (known after apply)
            }

          + resources {
              + core_fraction = (known after apply)
              + cores         = 2
              + gpus          = 0
              + memory        = 2
            }

          + scheduling_policy {
              + preemptible = true
            }
        }

      + maintenance_policy {
          + auto_repair  = true
          + auto_upgrade = true

          + maintenance_window {
              + day        = "saturday"
              + duration   = "3h"
              + start_time = "23:00"
            }
        }

      + scale_policy {
          + auto_scale {
              + initial = 1
              + max     = 2
              + min     = 1
            }
        }
    }

  # yandex_kubernetes_node_group.clusterNodes-b will be created
  + resource "yandex_kubernetes_node_group" "clusterNodes-b" {
      + cluster_id        = (known after apply)
      + created_at        = (known after apply)
      + description       = "k8s cluster for netology devops"
      + id                = (known after apply)
      + instance_group_id = (known after apply)
      + labels            = (known after apply)
      + name              = "cluster-nodes-b"
      + status            = (known after apply)
      + version           = "1.21"
      + version_info      = (known after apply)

      + allocation_policy {
          + location {
              + subnet_id = (known after apply)
              + zone      = "ru-central1-b"
            }
        }

      + deploy_policy {
          + max_expansion   = (known after apply)
          + max_unavailable = (known after apply)
        }

      + instance_template {
          + metadata                  = (known after apply)
          + nat                       = (known after apply)
          + network_acceleration_type = (known after apply)
          + platform_id               = "standard-v2"

          + boot_disk {
              + size = 64
              + type = "network-hdd"
            }

          + network_interface {
              + ipv4       = true
              + ipv6       = (known after apply)
              + nat        = true
              + subnet_ids = (known after apply)
            }

          + resources {
              + core_fraction = (known after apply)
              + cores         = 2
              + gpus          = 0
              + memory        = 2
            }

          + scheduling_policy {
              + preemptible = true
            }
        }

      + maintenance_policy {
          + auto_repair  = true
          + auto_upgrade = true

          + maintenance_window {
              + day        = "friday"
              + duration   = "3h"
              + start_time = "23:00"
            }
        }

      + scale_policy {
          + auto_scale {
              + initial = 1
              + max     = 2
              + min     = 1
            }
        }
    }

  # yandex_kubernetes_node_group.clusterNodes-c will be created
  + resource "yandex_kubernetes_node_group" "clusterNodes-c" {
      + cluster_id        = (known after apply)
      + created_at        = (known after apply)
      + description       = "k8s cluster for netology devops"
      + id                = (known after apply)
      + instance_group_id = (known after apply)
      + labels            = (known after apply)
      + name              = "cluster-nodes-c"
      + status            = (known after apply)
      + version           = "1.21"
      + version_info      = (known after apply)

      + allocation_policy {
          + location {
              + subnet_id = (known after apply)
              + zone      = "ru-central1-c"
            }
        }

      + deploy_policy {
          + max_expansion   = (known after apply)
          + max_unavailable = (known after apply)
        }

      + instance_template {
          + metadata                  = (known after apply)
          + nat                       = (known after apply)
          + network_acceleration_type = (known after apply)
          + platform_id               = "standard-v2"

          + boot_disk {
              + size = 64
              + type = "network-hdd"
            }

          + network_interface {
              + ipv4       = true
              + ipv6       = (known after apply)
              + nat        = true
              + subnet_ids = (known after apply)
            }

          + resources {
              + core_fraction = (known after apply)
              + cores         = 2
              + gpus          = 0
              + memory        = 2
            }

          + scheduling_policy {
              + preemptible = true
            }
        }

      + maintenance_policy {
          + auto_repair  = true
          + auto_upgrade = true

          + maintenance_window {
              + day        = "monday"
              + duration   = "3h"
              + start_time = "23:00"
            }
        }

      + scale_policy {
          + auto_scale {
              + initial = 1
              + max     = 2
              + min     = 1
            }
        }
    }

  # yandex_vpc_network.netology will be created
  + resource "yandex_vpc_network" "netology" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = (known after apply)
      + subnet_ids                = (known after apply)
    }

  # yandex_vpc_subnet.subnet-a will be created
  + resource "yandex_vpc_subnet" "subnet-a" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = (known after apply)
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "192.168.10.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

  # yandex_vpc_subnet.subnet-b will be created
  + resource "yandex_vpc_subnet" "subnet-b" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = (known after apply)
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "192.168.20.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-b"
    }

  # yandex_vpc_subnet.subnet-c will be created
  + resource "yandex_vpc_subnet" "subnet-c" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = (known after apply)
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "192.168.30.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-c"
    }

Plan: 9 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + cluster_external_v4_endpoint = (known after apply)
```