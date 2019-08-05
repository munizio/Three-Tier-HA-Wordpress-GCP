terraform {
  required_version = ">= 0.12"
}

# ------------------------------------------------------------
# Create Instance Group, Template, and Backend Service
# ------------------------------------------------------------

resource "google_compute_instance_group_manager" "web" {
  name = "${var.project}-web-igm"
  zone = var.zone

  instance_template   = "${google_compute_instance_template.web.self_link}"
  target_pools        = ["${google_compute_target_pool.public.self_link}"]
  base_instance_name  = "${var.project}-web-vm"

  target_size = 2
}

resource "google_compute_instance_template" "web" {
  machine_type = "f1-micro"

  disk {
    source_image = "ubuntu-1804-lts"
  }

  network_interface {
    network     = "${google_compute_network.private.name}"
    subnetwork  = "${google_compute_subnetwork.private.name}"
  }

  metadata = {
    block-project-ssh-keys = false
  }
  
  tags = ["web"]

}

