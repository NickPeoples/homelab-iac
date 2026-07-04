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

variable "networks" {
  description = "List of Docker networks to attach the container to."
  type        = list(string)
  default     = []
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
  description = "Map of environment variables to set in the container."
  type        = map(string)
  default     = {}
  sensitive   = true
}
