# modules/pihole-config/main.tf
terraform {
  required_version = "~> 1.12"

  required_providers {
    pihole = {
      source  = "lukaspustina/pihole"
      version = "~> 0.3"
    }
  }
}

resource "pihole_config" "this" {
  key   = var.key
  value = var.value
}
