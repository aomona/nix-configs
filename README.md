# NixOS / Darwin Configuration

A platform-first monorepo for managing NixOS, server, and macOS hosts with Home Manager.

## Directory Structure

```
.
├── flake.nix                  # Flake entry point
├── dotfiles/                  # Static config files (shell, etc.)
├── hosts/                     # Host entries (thin wrappers)
│   ├── nixos/                 # NixOS desktop host
│   │   ├── default.nix        # Imports profile + hardware + host data
│   │   ├── hardware-configuration.nix
│   │   └── host-data.nix      # Host-local literals (network, mounts, etc.)
│   ├── server/                # NixOS server host
│   │   ├── default.nix
│   │   ├── hardware-configuration.nix
│   │   └── host-data.nix
│   └── macbook/               # macOS host
│       ├── default.nix
│       ├── homebrew.nix
│       └── host-data.nix
├── modules/                   # System modules by platform
│   ├── nixos/                 # NixOS-only modules
│   │   ├── audio/
│   │   ├── boot/
│   │   ├── containers/
│   │   ├── desktop/
│   │   ├── flatpak/
│   │   ├── gaming/
│   │   ├── hardware/
│   │   ├── locale/
│   │   ├── networking/
│   │   ├── secrets/
│   │   ├── system/
│   │   ├── users/
│   │   └── virtualization/
│   ├── darwin/                # Darwin-only modules
│   │   ├── audio/
│   │   ├── boot/
│   │   ├── containers/
│   │   ├── desktop/
│   │   ├── flatpak/
│   │   ├── gaming/
│   │   ├── hardware/
│   │   ├── locale/
│   │   ├── networking/
│   │   ├── system/
│   │   ├── users/
│   │   └── virtualization/
│   └── shared/                # Cross-platform modules (placeholder)
├── profiles/                  # Platform profile aggregators
│   ├── nixos/
│   │   ├── desktop.nix        # Desktop NixOS module bundle
│   │   └── server.nix         # Server NixOS module bundle
│   └── darwin/
│       └── desktop.nix        # macOS module bundle
├── home/                      # Home Manager configuration
│   ├── profiles/              # Home Manager profiles
│   │   ├── desktop.nix        # Desktop user environment
│   │   ├── server.nix         # Server user environment
│   │   └── darwin.nix         # macOS user environment
│   ├── packages/              # Package groups by purpose
│   │   ├── core.nix           # Shared CLI tools
│   │   ├── desktop.nix        # Desktop applications
│   │   ├── development.nix    # Dev tools
│   │   ├── media.nix          # Media tools
│   │   ├── wayland.nix        # Wayland tools
│   │   ├── gaming.nix         # Gaming tools
│   │   ├── llm.nix            # LLM agents
│   │   ├── server.nix         # Server-specific packages
│   │   └── darwin.nix         # macOS-specific packages
│   └── programs/              # Per-program Home Manager configs
│       ├── git.nix
│       ├── nixvim/
│       ├── nushell.nix
│       └── ...
├── packages/                  # Overlays and custom derivations
├── secrets/                   # sops-nix encrypted secrets
│   ├── nixos/
│   ├── server/
│   ├── common/
│   └── darwin/
└── scripts/                   # Helper scripts
```

## Supported Outputs

| Output | Platform | Profile | Description |
|--------|----------|---------|-------------|
| `.#nixos` | NixOS (x86_64-linux) | `profiles/nixos/desktop.nix` | Desktop workstation |
| `.#server` | NixOS (x86_64-linux) | `profiles/nixos/server.nix` | Headless server |
| `.#macbook` | Darwin (aarch64-darwin) | `profiles/darwin/desktop.nix` | macOS laptop |

## Profile Model

This repo uses a two-level profile system:

1. **System profiles** under `profiles/<platform>/` aggregate platform-specific modules. A profile is a bundle of imports that defines what a host of that type should look like.
   - `profiles/nixos/desktop.nix` imports desktop NixOS modules (audio, gaming, Wayland, etc.)
   - `profiles/nixos/server.nix` imports server NixOS modules (containers, networking, etc.)
   - `profiles/darwin/desktop.nix` imports Darwin modules

2. **Host entries** under `hosts/<host>/` are thin wrappers that import a profile, hardware config, and host-local data. They do not contain feature logic.

3. **Home Manager profiles** under `home/profiles/` define the user environment for each host type. The flake wires the matching profile into each host's `home-manager.users.<name>`.

## Home Manager Profiles and Package Groups

Home Manager profiles live in `home/profiles/` and import package groups from `home/packages/`:

- `home/profiles/desktop.nix` imports `core`, `desktop`, `development`, `media`, `wayland`, `gaming`, `llm`
- `home/profiles/server.nix` imports `core`, `server`
- `home/profiles/darwin.nix` imports `core`, `development`, `darwin`, `llm`

Each package group is a standalone file that sets `home.packages`. Platform-specific conditionals inside these files keep Darwin from inheriting Linux-only tools.

## Secrets Policy (Path Freeze)

Encrypted secret paths are frozen during this refactor. Do not move, rename, or rekey tracked secret files.

Current encrypted secret files:

- `secrets/nixos/home.yaml` - contains `immich-api-key`, consumed by `modules/nixos/secrets/desktop.nix`

Other directories (`secrets/server/`, `secrets/common/`, `secrets/darwin/`) contain only placeholder `.gitkeep` files. No secret migration has happened.

Legacy container secrets at `/etc/nextcloud-adminpass` and `/etc/searx-env` remain host-local files and are not managed by sops-nix. Future work may migrate them.

## Verification Commands

```bash
# Check flake validity
nix flake check

# Dry-build a specific host
nixos-rebuild dry-build --flake .#nixos

# Build the Darwin configuration
nix run nix-darwin -- switch --flake .#macbook
```

## Adding a New Module

### NixOS system module

1. Create `modules/nixos/<domain>/<variant>.nix` (for example, `modules/nixos/monitoring/server.nix`)
2. Import it from the appropriate profile (`profiles/nixos/desktop.nix` or `profiles/nixos/server.nix`)

### Darwin system module

1. Create `modules/darwin/<domain>/default.nix`
2. Import it from `profiles/darwin/desktop.nix`

### Home Manager module

1. Create `home/programs/<name>.nix`
2. Import it from the appropriate `home/profiles/<profile>.nix`

### Home Manager package group

1. Create `home/packages/<group>.nix`
2. Import it from the appropriate `home/profiles/<profile>.nix`

## GitHub Actions

`.github/workflows/flake-update.yml` runs every 3 days and does the following when `flake.lock` changes:

1. Updates `flake.lock`
2. Builds `.#nixosConfigurations.${HOST_NAME:-nixos}.config.system.build.toplevel`
3. Pushes the result to Cachix
4. Commits and pushes the lock file

The workflow currently builds one configured Linux target. It does not validate Darwin or the server host.

Required secrets:

- `CACHIX_AUTH_TOKEN` - Actions secret
- `CACHIX_CACHE_NAME` - Actions variable (defaults to `akazdayo`)
