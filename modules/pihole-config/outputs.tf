# modules/pihole-config/outputs.tf
output "key" {
  description = "The configuration key that was set."
  value       = pihole_config.this.key
}
