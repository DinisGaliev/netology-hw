terraform {
  required_providers {
    yandex = { 
      source = "yandex-cloud/yandex"
    }
  }
}  


provider "yandex" { 
  zone = "ru-central1-b"
}

resource "yandex_compute_instance" "vm" {
  count = 2
  name = "vm${count.index}"
  platform_id = "standard-v1"
  boot_disk {
    initialize_params {
      image_id = "fd87j6d92jlrbjqbl32q" # ubuntu 22.04
      size = 8
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat = true
  }

  resources {
    core_fraction = 5
    cores = 2
    memory = 2
  }

metadata = { user-data = "${file("users.yml")}" }
}

resource "yandex_vpc_network" "network-1" {
  name = "network-1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name = "subnet-1"
  v4_cidr_blocks = [ "172.16.1.0/24" ]
  network_id = yandex_vpc_network.network-1.id
}

resource "yandex_lb_target_group" "demo-1" {
  name = "demo-1"
  target {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    address = yandex_compute_instance.vm[0].network_interface.0.ip_address
  }

  target {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    address = yandex_compute_instance.vm[1].network_interface.0.ip_address
  }
}

resource "yandex_lb_network_load_balancer" "lb-1" {
  name = "lb-1"
  deletion_protection = "false"
  listener {
    name = "my-lb1"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.demo-1.id
    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/"
      }
    }
  }   
}

output "lb-ip" {
  value = yandex_lb_network_load_balancer.lb-1.listener
}
 

