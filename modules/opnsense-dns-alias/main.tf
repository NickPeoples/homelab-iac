# modules/opnsense-dns-alias/main.tf
terraform {
  required_version = "~> 1.12"

  required_providers {
    opnsense = {
      source  = "browningluke/opnsense"
      version = "~> 0.23.0"
    }
  }
}

resource "opnsense_unbound_host_alias" "this" {
  enabled     = true
  override    = var.target_override_id
  hostname    = var.alias_hostname
  domain      = var.domain
  description = var.description
}
