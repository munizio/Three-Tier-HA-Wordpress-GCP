terraform {
  required_version = ">= 0.12"
}

# ------------------------------------------------------------ 
# Create Internal SubNetwork
# ------------------------------------------------------------ 

resource "google_compute_subnetwork" "mgmt" {
  name          = "${var.project}-mgmt-subnet"
  ip_cidr_range = "10.113.0.0/20"
  network       = "${google_compute_network.private.self_link}"
  region        = var.region
}

# ------------------------------------------------------------ 
# Public SSH to Bastion Rules
# ------------------------------------------------------------ 

resource "google_compute_firewall" "pub-ssh-bastion" {
  name    = "${var.project}-pub-ssh-bastion"
  project = var.project
  network = "${google_compute_network.private.self_link}"

  allow {
    protocol  = "tcp"
    ports     = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  
  target_tags = ["bastion"]
}

resource "google_compute_firewall" "ssh-from-bastion" { 
  name      = "${var.project}-ssh-from-bastion"
  project   = var.project
  network   = "${google_compute_network.private.self_link}"
  direction = "EGRESS"

  allow {
    protocol  = "tcp"
    ports     = ["22"]
  }

  target_tags = ["web"]
}

resource "google_compute_firewall" "ssh-to-bastion" {
  name      = "${var.project}-ssh-to-bastion"
  project   = var.project
  network   = "${google_compute_network.private.self_link}"
  direction = "INGRESS"

  allow {
    protocol  = "tcp"
    ports     = ["22"]
  }

  source_tags = ["bastion"]
}

