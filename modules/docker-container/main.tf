# modules/docker-container/main.tf
terraform {
  required_version = "~> 1.12"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

resource "docker_image" "this" {
  name         = var.image
  keep_locally = true
}

resource "docker_volume" "this" {
  for_each = toset(var.volumes)
  name     = each.key
}

resource "docker_container" "this" {
  name     = var.name
  image    = docker_image.this.image_id
  hostname = var.hostname
  restart  = "unless-stopped"

  dynamic "networks_advanced" {
    for_each = var.networks
    content {
      name = networks_advanced.value
    }
  }

  dynamic "volumes" {
    for_each = var.volume_mounts
    content {
      volume_name    = volumes.key
      container_path = volumes.value
    }
  }

  dynamic "ports" {
    for_each = var.ports
    content {
      internal = ports.value.internal
      external = ports.value.external
      protocol = lookup(ports.value, "protocol", "tcp")
    }
  }

  dynamic "labels" {
    for_each = var.labels
    content {
      label = labels.key
      value = labels.value
    }
  }

  env = [for k, v in var.env : "${k}=${v}"]
}
