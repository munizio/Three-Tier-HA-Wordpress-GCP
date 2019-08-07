terraform {
  required_version = ">= 0.12"
}

# ------------------------------------------------------------ 
# Create Edge IP and FW
# ------------------------------------------------------------ 

resource "google_compute_address" "public" {
  name = "${var.project}-pub-addr"
}

resource "google_compute_firewall" "public" {
  name    = "${var.project}-pub-fw"
  project = var.project
  network = "${google_compute_network.private.name}"

  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol  = "tcp"
    ports     = ["80", "443"]
  }
  
  target_tags = ["web"]
}

resource "google_compute_firewall" "pub-ssh-bastion" {
  name    = "${var.project}-pub-ssh-bastion"
  project = var.project
  network = "${google_compute_network.private.name}"

  allow {
    protocol  = "tcp"
    ports     = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  
  target_tags = ["bastion"]
}

# ------------------------------------------------------------ 
# Create Forwarding Rule, Target Pool, and Health Check
# ------------------------------------------------------------ 

resource "google_compute_forwarding_rule" "public" {
  name        = "${var.project}-pub-rule"
  target      = "${google_compute_target_pool.public.self_link}"
  ip_address  = "${google_compute_address.public.address}"
}

resource "google_compute_http_health_check" "public" {
  name                = "${var.project}-pub-hc"
  request_path        = "/"
  check_interval_sec  = 30
  timeout_sec         = 3
  healthy_threshold   = 2
  unhealthy_threshold = 2
  port                = "80"
}

resource "google_compute_target_pool" "public" {
  name              = "${var.project}-pool"
  health_checks     = ["${google_compute_http_health_check.public.name}"]
  session_affinity  = "CLIENT_IP"
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
  ip_cidr_range = "10.13.0.0/24"
  network       = "${google_compute_network.private.self_link}"
  region        = var.region
}

# ------------------------------------------------------------ 
# Create DMZ Network for SSH Bastion Host
# ------------------------------------------------------------ 

resource "google_compute_subnetwork" "dmz" {
  name          = "${var.project}-dmz-subnet"
  ip_cidr_range = "10.13.254.0/24"
  network       = "${google_compute_network.private.self_link}"
  region        = var.region
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

# ------------------------------------------------------------ 
# Create VPC Peering Settings
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



