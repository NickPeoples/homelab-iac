# modules/pihole-dns/outputs.tf
output "domain" {
  description = "Fully qualified domain name for this record."
  value       = pihole_dns_record.this.domain
}

output "ip_address" {
  description = "IP address this record resolves to."
  value       = pihole_dns_record.this.ip
}
