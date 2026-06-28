# modules/pihole-dns/main.tf
terraform {
  required_version = "~> 1.12"

  required_providers {
    pihole = {
      source  = "lukaspustina/pihole"
      version = "~> 0.3"
    }
  }
}

resource "pihole_dns_record" "this" {
  domain = "${var.hostname}.${var.domain}"
  ip     = var.ip_address
}
