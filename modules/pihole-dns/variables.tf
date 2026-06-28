# modules/pihole-dns/variables.tf
variable "hostname" {
  description = "Hostname without domain, e.g. 'proxmox0'."
  type        = string
}

variable "domain" {
  description = "Domain name the record belongs to, e.g. 'yourdomain.xyz'."
  type        = string
}

variable "ip_address" {
  description = "IP address the record resolves to."
  type        = string
}
