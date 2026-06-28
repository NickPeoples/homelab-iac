# modules/pihole-config/variables.tf
variable "key" {
  description = "PiHole configuration key, e.g. 'webserver.api.app_sudo' or 'misc.dnsmasq_lines'."
  type        = string
}

variable "value" {
  description = "Value to set for the given configuration key."
  type        = string
}
