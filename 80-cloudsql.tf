terraform {
  required_version = ">= 0.12"
}

# -------------------------------------------------- 
# Initialize Google Cloud SQL 
# -------------------------------------------------- 

resource "google_sql_database_instance" "db-instance" {
  project           = var.project
  name              = "${var.project}-db-instance-${random_id.db-id.hex}"
  database_version  = var.db_version
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
  name        = "wordpress"
  project     = var.project
  instance    = "${google_sql_database_instance.db-instance.name}"
  depends_on  = ["google_sql_database_instance.db-instance"]
}

resource "google_sql_user" "db-user" {
  name        = var.db_username
  project     = var.project
  instance    = "${google_sql_database_instance.db-instance.name}"
  password    = var.db_password
  depends_on  = ["google_sql_database_instance.db-instance"]
}

# ------------------------------------------------------------ 
# Initialize Google Cloud SQL Failover Replica
# ------------------------------------------------------------ 

resource "google_sql_database_instance" "db-failover-replica" {
  project               = var.project
  name                  = "${var.project}-db-failover-replica-${random_id.db-id.hex}"
  database_version      = var.db_version
  region                = var.region
  master_instance_name  = "${google_sql_database_instance.db-instance.name}"

  depends_on = [
    "google_sql_database_instance.db-instance"
  ]

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled    = "false"
      private_network = "${google_compute_network.private.self_link}"
    }
  }

  replica_configuration {
    failover_target = "true"
  }
}
