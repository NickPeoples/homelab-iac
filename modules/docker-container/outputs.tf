# modules/docker-container/outputs.tf
output "container_id" {
  description = "ID of the created Docker container."
  value       = docker_container.this.id
}

output "container_name" {
  description = "Name of the created Docker container."
  value       = docker_container.this.name
}

output "volume_mountpoints" {
  description = "Map of volume name to its mountpoint path on the host."
  value       = { for k, v in docker_volume.this : k => v.mountpoint }
}
