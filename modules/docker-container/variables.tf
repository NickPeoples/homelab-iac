# modules/docker-container/variables.tf
variable "name" {
  description = "Container name."
  type        = string
}

variable "image" {
  description = "Docker image to use, e.g. 'dxflrs/garage:v1.0.1'."
  type        = string
}

variable "hostname" {
  description = "Container hostname."
  type        = string
}

variable "network_mode" {
  description = "Docker network mode. Set to the primary network name for the container."
  type        = string
  default     = "bridge"
}

variable "networks" {
  description = "Additional networks to attach the container to beyond network_mode."
  type        = list(string)
  default     = []
}

variable "create_network" {
  description = "Whether to create a dedicated Docker network for this container."
  type        = bool
  default     = false
}

variable "network_name" {
  description = "Name of the dedicated network to create, if create_network is true."
  type        = string
  default     = ""
}

variable "volumes" {
  description = "List of Docker volume names to create."
  type        = list(string)
  default     = []
}

variable "volume_mounts" {
  description = "Map of volume name to container path."
  type        = map(string)
  default     = {}
}

variable "ports" {
  description = "List of port mappings."
  type = list(object({
    internal = number
    external = number
    protocol = optional(string, "tcp")
  }))
  default = []
}

variable "labels" {
  description = "Map of Docker labels to apply to the container."
  type        = map(string)
  default     = {}
}

variable "env" {
  description = "Map of environment variables."
  type        = map(string)
  default     = {}
  sensitive   = true
}

variable "log_opts" {
  description = "Docker log driver options."
  type        = map(string)
  default     = {}
}
