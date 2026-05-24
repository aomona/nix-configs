# OpenStack NixOS Provisioning

## Quick Start

```bash
# 1. Copy and fill in your values
cp terraform.tfvars.example terraform.tfvars
# Edit: set flavor_name, network_name, keypair_name, ssh_allowed_cidrs, external_network_name

# 2. Set OpenStack auth
source openrc.sh  # or set OS_* env vars, or export OS_CLOUD=mycloud

# 3. Enter the Nix dev shell (provides opentofu)
nix develop

# 4. Initialize
tofu -chdir=infra/openstack init

# 5. Plan (review changes before applying)
tofu -chdir=infra/openstack plan -var-file=terraform.tfvars

# 6. Apply
tofu -chdir=infra/openstack apply -var-file=terraform.tfvars

# 7. Get SSH host
tofu -chdir=infra/openstack output ssh_host

# 8. First deploy, building on the OpenStack VM
deploy --hostname "$(tofu -chdir=infra/openstack output -raw ssh_host)" --ssh-user root .#openstack

# 9. SSH into the VM after deploy
ssh akazdayo@$(tofu -chdir=infra/openstack output -raw ssh_host)
```

If you run the copy command from the repository root instead of inside `infra/openstack`, use:

```bash
cp infra/openstack/terraform.tfvars.example infra/openstack/terraform.tfvars
```

After the first deploy creates the configured user and disables root SSH login,
subsequent deploys can use the normal deploy-rs node:

```bash
deploy --hostname "$(tofu -chdir=infra/openstack output -raw ssh_host)" .#openstack
```

Alternatively, add an SSH config alias named `openstack` for the output host and
run `deploy .#openstack`.

The OpenStack user-data does not run `nixos-rebuild`; it only enables Nix
flakes on the base image so deploy-rs can perform the first remote build.
