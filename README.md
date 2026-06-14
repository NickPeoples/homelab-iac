# homelab-iac

Infrastructure as Code for homelab management using [OpenTofu](https://opentofu.org/) (or Terraform) with [Vaultwarden](https://github.com/dani-garcia/vaultwarden) as the secrets backend.

Covers infrastructure provisioning via OpenTofu and hands off to Ansible for system configuration. See your Ansible repository for the configuration layer.

---

## Repository structure

```
homelab-iac/
├── secrets/                  # Reusable Vaultwarden connector module
│   ├── providers.tf
│   ├── secrets.tf
│   ├── variables.tf
│   └── outputs.tf
├── modules/                  # Reusable infrastructure modules
│   ├── wireguard/
│   ├── opnsense/
│   └── proxmox/
├── environments/             # Per-environment root modules
│   ├── prod/
│   └── dev/
└── .gitignore
```

---

## Prerequisites

- [OpenTofu](https://opentofu.org/docs/intro/install/) or [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.6
- [Bitwarden CLI](https://bitwarden.com/help/cli/) (`bw`)
- A running [Vaultwarden](https://github.com/dani-garcia/vaultwarden) instance
- Access to [Bitwarden.com](https://bitwarden.com) as a disaster recovery backstop (recommended)

---

## Vaultwarden setup

### 1. Configure Vaultwarden

At minimum, set the following in your Vaultwarden environment config:

```env
DOMAIN=https://vaultwarden.yourhomelab.local
SIGNUPS_VERIFY=false
SIGNUPS_ALLOWED=true        # disable after creating your accounts
ADMIN_TOKEN=your-secret-admin-token
```

Access the admin panel at `https://vaultwarden.yourhomelab.local/admin` to manage accounts without needing an email broker.

### 2. Create accounts

Register two accounts directly in the web vault at `https://vaultwarden.yourhomelab.local`:

| Account | Purpose |
|---|---|
| `you@yourhomelab.local` | Your personal vault account |
| `automation@yourhomelab.local` | Service account used by Tofu and Ansible |

Once both accounts are created, disable open registration:

```env
SIGNUPS_ALLOWED=false
```

### 3. Create an organization

Log into the web vault as your personal account:

```
New organization → name it (e.g. HomeLab) → Free plan → Create
```

### 4. Invite the automation account

```
HomeLab → Members → Invite member → automation@yourhomelab.local → Role: Member
```

Log into the web vault as `automation@yourhomelab.local` and accept the invitation.

### 5. Create collections

```
HomeLab → Manage → Collections → New collection
```

Create the following collections:

| Collection | Purpose |
|---|---|
| `terraform` | Secrets consumed by OpenTofu only |
| `ansible` | Secrets consumed by Ansible only |
| `shared` | Secrets consumed by both tools |

### 6. Grant the automation account access to collections

```
HomeLab → Manage → Collections → terraform → Manage access → Add → automation@yourhomelab.local
```

Repeat for `ansible` and `shared`.

### 7. Create folders (optional)

Folders are for human navigation only and are not required by the Tofu module. Create them inside the web vault under your personal account if you want to organise secrets by system:

```
Add folder → opnsense
Add folder → proxmox
Add folder → wireguard
Add folder → test
```

### 8. Add a test secret

In the web vault, logged in as `automation@yourhomelab.local`:

```
New item → Type: Login
Name:       test_secret
Username:   test_user
Password:   test_password
Collection: terraform
Folder:     test (optional)
Save
```

### 9. Get the automation account API key

Log into the web vault as `automation@yourhomelab.local`:

```
Account Settings → Security → Keys → API Key → View API Key
```

Note the `client_id` and `client_secret`.

---

## Environment variables

All secrets are passed via environment variables. No secrets are committed to this repository.

```bash
export TF_VAR_bw_server="https://vaultwarden.yourhomelab.local"
export TF_VAR_bw_email="automation@yourhomelab.local"
export TF_VAR_bw_organization="HomeLab"
export TF_VAR_bw_client_id="your-client-id"
export TF_VAR_bw_client_secret="your-client-secret"
export TF_VAR_bw_master_password="your-master-password"
```

Add these to `~/.envrc` (if using [direnv](https://direnv.net/)) or your shell profile. Neither file should be committed to version control.

---

## The secrets module

The `secrets/` directory is a reusable module that authenticates against Vaultwarden and retrieves Login items and SSH keys by name. It is not a root module — it is called by environment root modules.

### Variables

| Variable | Description | Sensitive | Default |
|---|---|---|---|
| `bw_server` | Vaultwarden server URL | no | — |
| `bw_email` | Automation account email | no | — |
| `bw_organization` | Organization name to search | no | — |
| `bw_client_id` | API client ID | yes | — |
| `bw_client_secret` | API client secret | yes | — |
| `bw_master_password` | Master password | yes | — |
| `collection` | Collection to read from | no | `terraform` |
| `secret_names` | Login item names to fetch | no | `[]` |
| `ssh_key_names` | SSH key item names to fetch | no | `[]` |

### Outputs

| Output | Contents |
|---|---|
| `credentials` | Map of `{ username, password }` keyed by item name |
| `ssh_keys` | Map of `{ private_key, public_key }` keyed by item name |

Both outputs are marked `sensitive = true` and will not appear in plan or apply output.

---

## Usage

### Fetching login secrets from the default terraform collection

```hcl
module "secrets" {
  source = "../../secrets"

  bw_server          = var.bw_server
  bw_email           = var.bw_email
  bw_organization    = var.bw_organization
  bw_client_id       = var.bw_client_id
  bw_client_secret   = var.bw_client_secret
  bw_master_password = var.bw_master_password

  secret_names = ["test_secret"]
}

# consume the secret
output "test_username" {
  value     = module.secrets.credentials["test_secret"].username
  sensitive = true
}

output "test_password" {
  value     = module.secrets.credentials["test_secret"].password
  sensitive = true
}
```

### Fetching SSH keys from the shared collection

```hcl
module "shared_secrets" {
  source = "../../secrets"

  bw_server          = var.bw_server
  bw_email           = var.bw_email
  bw_organization    = var.bw_organization
  bw_client_id       = var.bw_client_id
  bw_client_secret   = var.bw_client_secret
  bw_master_password = var.bw_master_password

  collection    = "shared"
  ssh_key_names = ["ansible-ssh-key"]
}

# consume the SSH key
output "ansible_private_key" {
  value     = module.shared_secrets.ssh_keys["ansible-ssh-key"].private_key
  sensitive = true
}
```

### Fetching from both collections in the same environment

```hcl
module "secrets" {
  source       = "../../secrets"
  # ... auth vars ...
  secret_names = ["opnsense-api-key", "proxmox-api-token"]
}

module "shared_secrets" {
  source        = "../../secrets"
  # ... auth vars ...
  collection    = "shared"
  ssh_key_names = ["ansible-ssh-key"]
}

module "wg_example" {
  source = "../../modules/wireguard"

  preshared_key  = module.secrets.credentials["wg-example-preshared-key"].password
  ssh_public_key = module.shared_secrets.ssh_keys["ansible-ssh-key"].public_key
}
```

---

## Running a plan

```bash
# from an environment directory
cd environments/prod

tofu init
tofu plan
tofu apply
```

---

## Tofu vs Ansible — division of responsibility

| OpenTofu | Ansible |
|---|---|
| Infrastructure existence | System configuration |
| VM provisioning on Proxmox | Package installation |
| VLANs, firewall rules, WireGuard interfaces | Service config files |
| DNS records, DHCP reservations | App-level config |
| API-driven (OPNsense, Proxmox, Cloudflare) | SSH-driven |
| Secrets = API keys, tokens, preshared keys | Secrets = passwords, SSH keys, service credentials |

Tofu provisions and writes an Ansible inventory file. Ansible picks up from there.

---

## Recommended Vaultwarden collection and folder layout

```
HomeLab (organization)
├── terraform/
│   ├── opnsense/
│   │   ├── opnsense-api-key
│   │   └── opnsense-backup-password
│   ├── proxmox/
│   │   └── proxmox-api-token
│   ├── wireguard/
│   │   ├── wg-example-preshared-key
│   │   └── wg-example-private-key
│   └── test/
│       └── test_secret
├── ansible/
│   ├── linux/
│   │   ├── ansible-ssh-key
│   │   └── become-password
│   └── services/
│       └── service-passwords
└── shared/
    ├── proxmox/
    │   └── proxmox-root-password
    └── certificates/
        └── internal-ca-key
```

Folders are optional and for human navigation only. The Tofu module keys off item names within a collection, not folder paths.

---

## Disaster recovery

In a full loss scenario you will need:

- This repository
- Access to [Bitwarden.com](https://bitwarden.com) (cloud backup of your vault)
- Your master password and API key credentials

Point the provider at Bitwarden.com temporarily:

```bash
export TF_VAR_bw_server="https://vault.bitwarden.com"
```

Provision in this order:

1. OPNsense (networking)
2. Proxmox (hypervisor)
3. Vaultwarden VM
4. Repopulate local Vaultwarden from Bitwarden.com export
5. Switch `TF_VAR_bw_server` back to your local instance
6. Full `tofu apply`

See [disaster recovery notes](docs/disaster-recovery.md) for the full repopulation procedure.

---

## .gitignore coverage

The following are excluded from version control:

- `*.tfvars`, `*.auto.tfvars` — variable value files
- `.envrc`, `.env` — environment variable files
- `**/.terraform/` — provider cache
- `*.tfstate`, `*.tfstate.*` — state files
- `*.tfplan`, `*.plan` — plan output (may contain plaintext secrets)
- `**/.bitwarden/` — local Vaultwarden CLI cache
- SSH key files (`*.pem`, `*.key`, `id_rsa`, `id_ed25519`)

---

## Provider versions

| Provider | Source | Version |
|---|---|---|
| bitwarden | `maxlaverse/bitwarden` | `~> 0.17.6` |
