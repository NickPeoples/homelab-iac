# secrets/secrets.tf
data "bitwarden_organization" "homelab" {
  search = var.bw_organization
}

data "bitwarden_org_collection" "target" {
  search          = var.collection
  organization_id = data.bitwarden_organization.homelab.id
}

data "bitwarden_item_login" "secrets" {
  for_each = toset(var.secret_names)

  search                 = each.key
  filter_organization_id = data.bitwarden_organization.homelab.id
  filter_collection_id   = data.bitwarden_org_collection.target.id
}

data "bitwarden_item_ssh_key" "ssh_keys" {
  for_each = toset(var.ssh_key_names)

  search                 = each.key
  filter_organization_id = data.bitwarden_organization.homelab.id
  filter_collection_id   = data.bitwarden_org_collection.target.id
}
