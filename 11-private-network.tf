terraform {
  required_version = ">= 0.12"
}

# ------------------------------------------------------------ 
# Create Internal FW
# ------------------------------------------------------------ 

resource "google_compute_firewall" "private" {
  name    = "${var.project}-pri-fi"
  network = "default"

  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol  = "tcp"
    ports     = ["80"]
  }
}

# ------------------------------------------------------------ 
# Create Internal Network
# ------------------------------------------------------------ 

resource "google_compute_network" "private" {
  project                 = var.project
  name                    = "${var.project}-pri-net"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "private" {
  name          = "${var.project}-subnet"
  ip_cidr_range = "10.13.0.0/20"
  network       = "${google_compute_network.private.self_link}"
  region        = var.region
}

# ------------------------------------------------------------ 
# Create VPC Network for Cloud SQL Instance
# ------------------------------------------------------------ 

resource "google_compute_global_address" "private" {
  name          = "${var.project}-pri-ip"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  network       = "${google_compute_network.private.self_link}"
}

resource "google_service_networking_connection" "private" {
  network                 = "${google_compute_network.private.self_link}"
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = ["${google_compute_global_address.private.self_link}"]
}


