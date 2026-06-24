# modules/opnsense-dns-alias/variables.tf
variable "alias_hostname" {
  description = "Hostname for the alias (CNAME), without domain."
  type        = string
}

variable "target_hostname" {
  description = "Hostname of the existing host override this alias points to, without domain."
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
