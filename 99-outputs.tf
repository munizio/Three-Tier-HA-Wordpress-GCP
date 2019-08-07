terraform {
  required_version = ">= 0.12"
}

# ------------------------------------------------------------ 
# Declare Terraform Output Values
# ------------------------------------------------------------ 

output "lb_address" {
  value = "${google_compute_address.public.address}"
}

output "ssh_address" {
  value = "${google_compute_instance.bastion.network_interface.0.access_config.0.nat_ip}"
}

output "db-instance-ip" {
  value = "${google_sql_database_instance.db-instance.private_ip_address}"
}
