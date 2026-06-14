# secrets/outputs.tf
output "credentials" {
  sensitive = true
  value = {
    for name, item in data.bitwarden_item_login.secrets :
    name => {
      username = item.username
      password = item.password
    }
  }
}

output "ssh_keys" {
  sensitive = true
  value = {
    for name, item in data.bitwarden_item_ssh_key.ssh_keys :
    name => {
      private_key = item.private_key
      public_key  = item.public_key
    }
  }
}
