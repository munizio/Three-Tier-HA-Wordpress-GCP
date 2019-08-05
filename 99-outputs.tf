output "lb_address" {
  value = "${google_compute_address.public.address}"
}

output "ssh_address" {
  value = "${google_compute_instance.bastion.network_interface.0.access_config.0.nat_ip}"
}
