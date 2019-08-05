resource "google_storage_bucket" "gcs" {
  name    = "${var.project}-gcs"
  project = var.project
}

