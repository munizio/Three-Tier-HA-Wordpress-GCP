resource "google_sql_database_instance" "db-instance" {
  project           = var.project
  name              = "${var.project}-db-instance-${random_id.db-id.hex}"
  database_version  = "MYSQL_5_7" 
  region            = var.region
  
  depends_on = [
    "google_service_networking_connection.private"
  ]

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled    = "false"
      private_network = "${google_compute_network.private.self_link}"
    }
  }
}

resource "google_sql_database" "db" {
  name        = "${var.project}-db"
  project     = var.project
  instance    = "${google_sql_database_instance.db-instance.name}"
  depends_on  = ["google_sql_database_instance.db-instance"]
}

resource "google_sql_user" "db-user" {
  name        = var.db-username
  project     = var.project
  instance    = "${google_sql_database_instance.db-instance.name}"
  password    = var.db-password
  depends_on  = ["google_sql_database_instance.db-instance"]
}

