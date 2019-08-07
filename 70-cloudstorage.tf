terraform {
  required_version = ">= 0.12"
}

# ------------------------------------------------------------ 
# Initialize Google Cloud Storage Bucket
# ------------------------------------------------------------ 

resource "google_storage_bucket" "gcs" {
  name    = "${var.project}-gcs"
  project = var.project
}

