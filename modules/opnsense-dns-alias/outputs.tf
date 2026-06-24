# modules/opnsense-dns-alias/outputs.tf
output "hostname" {
  description = "The alias hostname configured."
  value       = opnsense_unbound_host_alias.this.hostname
}
