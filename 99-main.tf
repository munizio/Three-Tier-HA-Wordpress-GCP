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
