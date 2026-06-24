# modules/opnsense-dns/outputs.tf
output "hostname" {
  description = "The hostname configured for this record."
  value       = opnsense_unbound_host_override.this.hostname
}

output "fqdn" {
  description = "Fully qualified domain name for this record."
  value       = "${var.hostname}.${var.domain}"
}
