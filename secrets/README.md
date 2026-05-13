# Secrets

This directory contains secrets encrypted with [sops](https://github.com/getsops/sops) and managed by [sops-nix](https://github.com/Mic92/sops-nix).

## Setup

### 1. Generate YubiKey age key

```bash
age-plugin-yubikey --generate --slot 1 --touch-policy always --name "primary"
```

### 2. Get your YubiKey recipient (public key)

```bash
age-plugin-yubikey --list-all
```

Copy the `age1yubikey1...` string and replace `age1replace-with-your-yubikey-recipient` in `.sops.yaml`.

### 3. Get host SSH-derived age recipients

On each host, run:

```bash
ssh-to-age -i /etc/ssh/ssh_host_ed25519_key.pub
```

Replace the placeholders in `.sops.yaml` with the actual values.

### 4. Host SSH key setup

This configuration uses SSH host keys for secret decryption (no YubiKey required for unattended boot).

On each host, the SSH host public key is converted to an age recipient:

```bash
ssh-to-age -i /etc/ssh/ssh_host_ed25519_key.pub
```

Add this output to `.sops.yaml` under the appropriate host key.

No private key files need to be copied - sops-install-secrets reads `/etc/ssh/ssh_host_ed25519_key` directly.

### 5. Create encrypted secrets

```bash
sops secrets/nixos/home.yaml
```

Example content:

```yaml
immich-api-key: your-actual-api-key-here
```

Save and exit - sops will encrypt automatically.

## Directory Structure

- `nixos/home.yaml` - Desktop home-manager secrets
- `server/system.yaml` - Server system secrets
- `common/` - Shared secrets accessible to all hosts
- `darwin/` - macOS home-manager secrets

Encrypted secret files must be tracked by git so they are included in the nix store during pure evaluation.

## Replacing the Dummy Secret

`secrets/nixos/home.yaml` currently contains a dummy `immich-api-key` encrypted to the nixos host SSH key. Recreate it with your real secret:

```bash
rm secrets/nixos/home.yaml
sops secrets/nixos/home.yaml
# Add: immich-api-key: your-real-api-key
# Save and exit - sops will encrypt with the host SSH key
```

### Security Note

This configuration uses SSH host keys for decryption. Anyone with root access to the host (who can read `/etc/ssh/ssh_host_ed25519_key`) can decrypt these secrets. This is a trade-off for unattended boot support.

## Adding a New Secret

1. Define it in the appropriate module:
   - Home-manager secrets: `home/programs/secrets.nix`
   - System secrets: `modules/secrets/desktop.nix` or `server.nix`
2. Add the secret value to the corresponding `.yaml` file via `sops <path>`
3. Rebuild: `sudo nixos-rebuild switch --flake .#nixos`

## Rotating Keys

After adding a new recipient to `.sops.yaml`:

```bash
sops updatekeys secrets/nixos/home.yaml
sops updatekeys secrets/server/system.yaml
```
