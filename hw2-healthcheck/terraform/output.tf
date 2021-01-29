output "external_ip_nginx" {
  value = yandex_compute_instance.nginx.network_interface.0.nat_ip_address
}
