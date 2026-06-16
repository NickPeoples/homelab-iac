# secrets/outputs.tf
output "credentials" {
  description = "Map of login item names to their username and password, retrieved from Vaultwarden."
  sensitive   = true
  value = {
    for name, item in data.bitwarden_item_login.secrets :
    name => {
      username = item.username
      password = item.password
    }
  }
}

output "ssh_keys" {
  description = "Map of SSH key item names to their private and public keys, retrieved from Vaultwarden."
  sensitive   = true
  value = {
    for name, item in data.bitwarden_item_ssh_key.ssh_keys :
    name => {
      private_key = item.private_key
      public_key  = item.public_key
    }
  }
}
