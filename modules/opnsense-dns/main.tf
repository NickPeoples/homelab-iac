# modules/opnsense-dns/main.tf
terraform {
  required_version = "~> 1.12"
  required_providers {
    opnsense = {
      source  = "browningluke/opnsense"
      version = "~> 0.23.0"
    }
  }
}

resource "opnsense_unbound_host_override" "this" {
  enabled     = true
  hostname    = var.hostname
  domain      = var.domain
  type        = var.record_type
  server      = var.ip_address
  description = var.description
}
