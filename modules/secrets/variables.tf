# secrets/variables.tf
variable "bw_organization" {
  description = "Vaultwarden organization name to search for"
  type        = string
}

variable "bw_server" {
  description = "Vaultwarden server URL"
  type        = string
}

variable "bw_email" {
  description = "Vaultwarden account email"
  type        = string
}

variable "bw_client_id" {
  description = "Vaultwarden API client ID"
  type        = string
  sensitive   = true
}

variable "bw_client_secret" {
  description = "Vaultwarden API client secret"
  type        = string
  sensitive   = true
}

variable "bw_master_password" {
  description = "Vaultwarden master password"
  type        = string
  sensitive   = true
}

variable "collection" {
  description = "Vaultwarden collection to read from (e.g. terraform, ansible)"
  type        = string
  default     = "terraform"
}

variable "secret_names" {
  description = "List of item names to fetch from the collection"
  type        = list(string)
  default     = []
}

variable "ssh_key_names" {
  description = "List of SSH key item names to fetch from the collection"
  type        = list(string)
  default     = []
}
