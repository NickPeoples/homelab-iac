# modules/opnsense-dns/variables.tf
variable "hostname" {
  description = "Hostname without domain, e.g. 'proxmox0'. Use '*' for a wildcard record."
  type        = string
}

variable "domain" {
  description = "Domain name the record belongs to, e.g. 'yourdomain.com'."
  type        = string
}

variable "record_type" {
  description = "DNS record type, e.g. 'A' or 'AAAA'."
  type        = string
  default     = "A"
}

variable "ip_address" {
  description = "IP address the record resolves to."
  type        = string
}

variable "description" {
  description = "Optional description shown in the OPNsense UI."
  type        = string
  default     = ""
}
