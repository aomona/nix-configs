# OpenStack NixOS Provisioning

Provision infrastructure with OpenTofu, deploy NixOS with deploy-rs.

## Quick Start

```bash
# 1. Copy and fill in your values
cp terraform.tfvars.example terraform.tfvars
# Edit: set flavor_name, network_name, keypair_name, ssh_allowed_cidrs, external_network_name

# 2. Set OpenStack auth
source openrc.sh  # or set OS_* env vars, or export OS_CLOUD=mycloud

# 3. Enter the Nix dev shell (provides opentofu + deploy-rs)
nix develop

# 4. Initialize
tofu -chdir=infra/openstack init

# 5. Plan (review changes before applying)
tofu -chdir=infra/openstack plan -var-file=terraform.tfvars

# 6. Apply (provisions VM, network, security group; creates deploy-rs user)
tofu -chdir=infra/openstack apply -var-file=terraform.tfvars

# 7. Verify bootstrap (should return without error)
ssh deploy@$(tofu -chdir=infra/openstack output -raw ssh_host) 'sudo -n true'

# 8. Deploy NixOS config via deploy-rs (wraps --hostname resolution)
nix run .#deploy-openstack

# 9. SSH into the deployed system
ssh akazdayo@$(tofu -chdir=infra/openstack output -raw ssh_host)
```

## Subsequent Updates

```bash
# Pull latest config, then deploy (no tofu needed)
nix run .#deploy-openstack
```

## Workflow Summary

| Stage | Tool | What It Does |
|-------|------|-------------|
| Provision | `tofu apply` | Creates VM, port, security group. Bootstrap creates `deploy` user with SSH keys + NOPASSWD sudo. |
| Deploy | `nix run .#deploy-openstack` | Connects as `deploy` user, pushes NixOS closure via deploy-rs. |
| Update | `nix run .#deploy-openstack` | Pushes updated NixOS closure. TF not needed for config changes. |

If you run the copy command from the repository root instead of inside `infra/openstack`, use:

```bash
cp infra/openstack/terraform.tfvars.example infra/openstack/terraform.tfvars
```
