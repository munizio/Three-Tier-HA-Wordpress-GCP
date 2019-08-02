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
  network = "${google_compute_network.private.name}"

  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol  = "tcp"
    ports     = ["80"]
  }
}

# ------------------------------------------------------------ 
# Create Forwarding Rule, Pool, and Health Check
# ------------------------------------------------------------ 

resource "google_compute_forwarding_rule" "public" {
  name        = "${var.project}-pub-rule"
  target      = "${google_compute_target_pool.public.self_link}"
  port_range  = "80"
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
  name          = "${var.project}-pool"
  health_checks = ["${google_compute_http_health_check.public.name}"]
}

