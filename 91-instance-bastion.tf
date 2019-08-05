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
    subnetwork  = "${google_compute_subnetwork.mgmt.name}"

    access_config {
      # Ephemeral IP
    }
  }

  tags = ["bastion"]
}

 
    
