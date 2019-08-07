terraform {
  required_version = ">= 0.12"
}

# ------------------------------------------------------------ 
# Declaire Project Wide Variables
# ------------------------------------------------------------ 

variable "account" {
  default = "./gcp-account.json"
}

variable "project" {
  default = "rlt-hackathon-248519"
}

variable "region" {
  default = "us-central1"
}

variable "zone" {
  default = "us-central1-a"
}

variable "db_username" {
  default = "wp-db-user"
}

variable "db_password" {
  default = "wonderful-relish-Bouncing-9204"
}

variable "db_version" {
  default = "MYSQL_5_7"
}

variable "ssh_username" {
  default = "n388mm"
}

variable "ssh_key" {
  default = "./.ssh/pub_gcloud.pub"
}
