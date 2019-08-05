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

variable "db-username" {
  default = "wp-db-user"
}

variable "db-password" {
  default = "wonderful-relish-Bouncing-9204"
}

variable "ssh-username" {
  default = "n388mm"
}

variable "ssh-key" {
  default = "./.ssh/pub_gcloud.pub"
}
