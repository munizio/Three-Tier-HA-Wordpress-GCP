terraform {
  required_version = ">= 0.12"
}

# ------------------------------------------------------------ 
# Create Single Compute Instance as SSH Bastion Host
# ------------------------------------------------------------ 
  
resource "google_compute_instance" "bastion" {
  name          = "${var.project}-bastion-vm"
  project       = var.project
  machine_type  = "f1-micro"
  zone          = var.zone

  metadata = {
    block-project-ssh-keys = false
  }

  boot_disk {
    initialize_params {
      image = "ubuntu-1804-lts"
    }
  }

  network_interface {
    network     = "${google_compute_network.private.name}"
    subnetwork  = "${google_compute_subnetwork.dmz.name}"

    access_config {
      # Ephemeral IP
    }
  }

  tags = ["bastion"]
 
  # ------------------------------------------------------------ 
  # Automate Running of Ansible-Playbook 
  # ------------------------------------------------------------ 

  provisioner "local-exec" {
      command = "sleep 60"
  }

  provisioner "local-exec" {
    command = "ansible-playbook main.yml -i inventory.gcp.yml --extra-vars \"wp_db_host=${google_sql_database_instance.db-instance.private_ip_address} wp_db_user=${var.db_username} wp_db_password=${var.db_password}\""
  }
}
