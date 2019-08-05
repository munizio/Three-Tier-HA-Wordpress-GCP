terraform {
  required_version = ">= 0.12"
}

# ------------------------------------------------------------ 
# Initialize GCP Provider
# ------------------------------------------------------------ 

provider "google" {
  credentials = var.account
  project     = var.project
  region      = var.region
}

resource "random_id" "db-id" {
  byte_length = 8
}

resource "google_compute_project_metadata" "ssh" {
  metadata = {
    ssh-keys = "${var.ssh-username}:${file(var.ssh-key)}"
  }
}
