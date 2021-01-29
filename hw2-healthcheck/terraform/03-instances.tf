data "yandex_compute_image" "container-optimized-image" {
  family = "container-optimized-image"
}

resource "yandex_compute_instance" "backend1" {
  name = "backend1"
  hostname = "backend1"
  service_account_id = var.puller_service_account_id

  resources {
    cores = 2
    memory = 2
    core_fraction = 5
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.container-optimized-image.id
      size = var.instance_root_disk
    }
  }

  metadata = {
    ssh-keys = "tfk:${file("~/.ssh/id_rsa.pub")}"
    docker-container-declaration = file("${path.module}/backend.yaml")
    user-data = file("${path.module}/cloud_config.yaml")
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.hw2-subnet.id
  }

  scheduling_policy {
    preemptible = true
  }
}

resource "yandex_compute_instance" "backend2" {
  name = "backend2"
  hostname = "backend2"
  service_account_id = var.puller_service_account_id

  resources {
    cores = 2
    memory = 2
    core_fraction = 5
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.container-optimized-image.id
      size = var.instance_root_disk
    }
  }

  metadata = {
    ssh-keys = "tfk:${file("~/.ssh/id_rsa.pub")}"
    docker-container-declaration = file("${path.module}/backend.yaml")
    user-data = file("${path.module}/cloud_config.yaml")
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.hw2-subnet.id
  }

  scheduling_policy {
    preemptible = true
  }
}

resource "yandex_compute_instance" "nginx" {
  name = "nginx"
  service_account_id = var.puller_service_account_id

  resources {
    cores = 2
    memory = 2
    core_fraction = 5
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.container-optimized-image.id
      size = var.instance_root_disk
    }
  }

  metadata = {
    ssh-keys = "tfk:${file("~/.ssh/id_rsa.pub")}"
    docker-container-declaration = file("${path.module}/nginx.yaml")
    user-data = file("${path.module}/cloud_config.yaml")
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.hw2-subnet.id
    nat = true
  }

  scheduling_policy {
    preemptible = true
  }
}

resource "yandex_compute_instance" "postgresql" {
  name = "postgresql"
  hostname = "postgresql"
  service_account_id = var.puller_service_account_id

  resources {
    cores = 2
    memory = 2
    core_fraction = 5
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.container-optimized-image.id
      size = var.instance_root_disk
    }
  }

  metadata = {
    ssh-keys = "tfk:${file("~/.ssh/id_rsa.pub")}"
    docker-container-declaration = file("${path.module}/postgresql.yaml")
    user-data = file("${path.module}/cloud_config.yaml")
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.hw2-subnet.id
  }

  scheduling_policy {
    preemptible = true
  }
}

resource "yandex_compute_instance" "nat-instance" {
  name = "nat-instance"

  resources {
    cores = 2
    memory = 2
    core_fraction = 5
  }

  boot_disk {
    auto_delete = true

    initialize_params {
      image_id = "fd80mrhj8fl2oe87o4e1"
      size = var.instance_root_disk
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.hw2-nat-subnet.id
    nat = true
  }

  metadata = {
    ssh-keys = "tfk:${file("~/.ssh/id_rsa.pub")}"
  }
}
