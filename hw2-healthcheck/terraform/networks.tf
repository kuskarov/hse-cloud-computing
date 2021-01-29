resource "yandex_vpc_network" "hw2-network" {
  name = "hw2-network"
}

resource "yandex_vpc_route_table" "nat-route-table" {
  network_id = yandex_vpc_network.hw2-network.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address = yandex_compute_instance.nat-instance.network_interface.0.ip_address
  }
}

resource "yandex_vpc_subnet" "hw2-subnet" {
  name = "hw2-subnet"
  zone = var.zone
  network_id = yandex_vpc_network.hw2-network.id
  v4_cidr_blocks = [
    "10.10.10.0/24"]
  route_table_id = yandex_vpc_route_table.nat-route-table.id
}

resource "yandex_vpc_subnet" "hw2-nat-subnet" {
  name = "hw2-nat-subnet"
  zone = var.zone
  network_id = yandex_vpc_network.hw2-network.id
  v4_cidr_blocks = [
    "10.10.9.0/24"]
}
