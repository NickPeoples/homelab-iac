# secrets/providers.tf
terraform {
  required_providers {
    bitwarden = {
      source  = "maxlaverse/bitwarden"
      version = "~> 0.17.6"
    }
  }
}

provider "bitwarden" {
  server          = var.bw_server
  client_id       = var.bw_client_id
  client_secret   = var.bw_client_secret
  master_password = var.bw_master_password
  email           = var.bw_email
}
