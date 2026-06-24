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

data "opnsense_unbound_host_override" "target" {
  hostname = var.target_hostname
  domain   = var.domain
}

resource "opnsense_unbound_host_alias" "this" {
  enabled     = true
  host        = data.opnsense_unbound_host_override.target.id
  hostname    = var.alias_hostname
  domain      = var.domain
  description = var.description
}
