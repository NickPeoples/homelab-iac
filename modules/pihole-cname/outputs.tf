# modules/pihole-cname/outputs.tf
output "domain" {
  description = "Fully qualified alias domain name."
  value       = pihole_cname_record.this.domain
}

output "target" {
  description = "Fully qualified target domain name this alias points to."
  value       = pihole_cname_record.this.target
}
