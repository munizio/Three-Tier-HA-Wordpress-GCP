terraform {
  required_version = ">= 0.12"
}

# ------------------------------------------------------------ 
# Create Internal Network
# ------------------------------------------------------------ 

resource "google_compute_network" "private" {
  project                 = var.project
  name                    = "${var.project}-net"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "private" {
  name          = "${var.project}-pri-subnet"
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
  prefix_length = 16
}

resource "google_service_networking_connection" "private" {
  network                 = "${google_compute_network.private.self_link}"
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = ["${google_compute_global_address.private.name}"]
}


