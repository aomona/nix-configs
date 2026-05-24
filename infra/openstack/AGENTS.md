# infra/openstack

**Generated:** 2026-05-22 | **Commit:** 951517d
Parent: [root AGENTS.md](../../AGENTS.md)

## OVERVIEW
OpenTofu/Terraform IaC for provisioning NixOS VMs on OpenStack. Uses minimal cloud-init to prepare SSH access for deploy-rs, which is the primary NixOS deployment mechanism.

## STRUCTURE
```
infra/openstack/
├── main.tf                  # Compute instance, networking, floating IP, security group
├── variables.tf             # Input variables (instance name, flavor, image, network, keypair)
├── outputs.tf               # instance_id, fixed_ip, floating_ip, ssh_host
├── providers.tf             # OpenStack provider (auth from env, NOT tracked)
├── versions.tf              # OpenTofu >= 1.6.0, openstack provider ~> 3.4
├── user-data.sh.tftpl        # Bootstrap template: creates deploy-rs user with SSH keys + sudo
├── terraform.tfvars.example # Example variable values
├── .terraform.lock.hcl      # Lock file — TRACKED in git
├── README.md                # Full provisioning guide
└── AGENTS.md                # This file
```

## WHERE TO LOOK
| Task | Location | Notes |
|------|----------|-------|
| Change instance config | `main.tf` | Compute, network, security group, floating IP |
| Add/change input vars | `variables.tf` | New vars need `terraform.tfvars.example` entry |
| Change bootstrap script | `user-data.sh.tftpl` | Shell script injected via config-drive |
| Debug bootstrap | `README.md` | amazon-init status, manual bootstrap steps |
| Validate offline | `README.md` | `tofu validate` without credentials |

## CONVENTIONS
- **Auth from env, never tracked**: `openrc.sh` sources `OS_*` env vars. No credentials in tracked files. Provider config uses env vars + `OS_CLOUD` fallback.
- **State gitignored, lockfile tracked**: `*.tfstate` and `*.tfvars` are in `.gitignore`. `.terraform.lock.hcl` IS tracked.
- **Keypair preference**: Always use an existing `keypair_name` — avoids generating private keys in Terraform state.
- **CIDR rules**: Never `0.0.0.0/0`. Always explicit CIDR blocks for SSH access.
- **Persistent VM with lifecycle guard**: `lifecycle { ignore_changes = [user_data] }` protects the VM from being replaced when bootstrap script changes. Review changes with `tofu plan` before applying.
- **Deploy-rs is the sole deployment mechanism**: NixOS config is pushed via `nix run .#deploy-openstack` which wraps tofu output resolution + deploy-rs. No bootstrap-time rebuild.

## COMMANDS
```bash
# Authentication
source ../../openrc.sh                     # or set OS_* env vars

# From repo root
nix develop                                # provides opentofu + deploy-rs
tofu -chdir=infra/openstack init
tofu -chdir=infra/openstack plan -var-file=terraform.tfvars
tofu -chdir=infra/openstack apply -var-file=terraform.tfvars
tofu -chdir=infra/openstack output ssh_host

# Deploy NixOS (resolves SSH host from tofu output)
nix run .#deploy-openstack

# Offline validation (no credentials)
nix develop -c tofu -chdir=infra/openstack fmt -check
nix develop -c tofu -chdir=infra/openstack init -backend=false
nix develop -c tofu -chdir=infra/openstack validate -var-file=terraform.tfvars.example
```

## ANTI-PATTERNS
- Committing `terraform.tfvars` (contains real values, must remain gitignored).
- Committing auth credentials (API keys, tokens, `clouds.yaml` secrets).
- Using `0.0.0.0/0` for `ssh_allowed_cidrs` — always restrict to your IP range.
- Running `tofu apply` before `tofu plan` — review changes first.
- Changing `image_id`, `config_drive`, or `key_pair` on a live instance — destroys and recreates the VM. Use `tofu plan` to confirm.

## NOTES
- Bootstrap uses **amazon-init** (NixOS built-in) to execute user_data as a shell script. Creates the `deploy` user with SSH keys and NOPASSWD sudo for deploy-rs. Does NOT run `nixos-rebuild`. Logs to `/var/log/nixos-bootstrap.log`.
- First-boot SSH goes to `root` (OpenStack keypair injection). After bootstrap, the `deploy` user is created with the same authorized keys.
- The IP address is **not hardcoded** in flake.nix. Use the `nix run .#deploy-openstack` wrapper which resolves the SSH host from tofu output automatically.
- The VM persists across config changes — `user_data` changes are ignored via lifecycle policy to prevent accidental replacement.
- The VM is considered **persistent** — infrastructure changes should be reviewed via `tofu plan` before applying.
