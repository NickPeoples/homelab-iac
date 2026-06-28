# modules/pihole-cname/main.tf
terraform {
  required_version = "~> 1.12"

  required_providers {
    pihole = {
      source  = "lukaspustina/pihole"
      version = "~> 0.3"
    }
  }
}

resource "pihole_cname_record" "this" {
  domain = "${var.alias_hostname}.${var.domain}"
  target = "${var.target_hostname}.${var.domain}"
}
