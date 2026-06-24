# modules/opnsense-dns-alias/variables.tf
variable "alias_hostname" {
  description = "Hostname for the alias (CNAME), without domain."
  type        = string
}

variable "target_override_id" {
  description = "ID of the existing opnsense_unbound_host_override resource this alias points to."
  type        = string
}

variable "domain" {
  description = "Domain shared by both the alias and its target."
  type        = string
}

variable "description" {
  description = "Optional description shown in the OPNsense UI."
  type        = string
  default     = ""
}
