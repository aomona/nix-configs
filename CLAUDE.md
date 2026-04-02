# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a modular NixOS configuration using Flakes and Home Manager for user "akazdayo". It manages two hosts: `nixos` (desktop) and `server`, with a clear separation between shared system-level modules (`modules/`), host composition (`hosts/`), and user-level settings (`home/`).

## Common Commands

### Build and Apply Configuration
```bash
# Apply desktop configuration (preferred: uses nh for cleaner output)
nh os switch

# Apply with explicit flake target
sudo nixos-rebuild switch --flake .#nixos   # desktop
sudo nixos-rebuild switch --flake .#server  # server

# Test without making default boot option
sudo nixos-rebuild test --flake .#nixos

# Dry build to check for errors
nixos-rebuild dry-build --flake .#nixos

# Check flake for issues
nix flake check
```

### Updating Dependencies
```bash
# Update all flake inputs
nix flake update

# Update specific input
nix flake lock --update-input nixpkgs
nix flake lock --update-input nixpkgs-unstable
```

## Architecture

### Flake Structure
- Two nixpkgs inputs: `nixpkgs` (25.11 stable) and `nixpkgs-unstable`
- Key flake inputs: `home-manager`, `nixvim`, `lanzaboote` (secure boot), `nix-flatpak`, `noctalia` (QuickShell), `llm-agents`
- Two host factory functions in `flake.nix`: `mkHost` (desktop) and `mkServer`
- `specialArgs` passed to NixOS modules: `self`, `inputs`, `pkgs-unstable`, `hostMeta`
- `extraSpecialArgs` passed to Home Manager: `pkgs-unstable`, `pkgs-with-llm-agents`, `inputs`, `hostMeta`, `nixvim-module`
- `hostMeta` contains: `hostName`, `system`, `primaryUser`, `flakeRoot`

### Module Naming Convention
Modules use a host-type suffix pattern: `desktop.nix` for the desktop host, `server.nix` for the server. A parent `desktop.nix` or `server.nix` in each category often imports sub-modules (e.g., `modules/gaming/desktop.nix` imports `steam.nix`, `wivrn.nix`, `slimevr.nix`).

### Host Composition
- **Desktop** (`hosts/nixos`): imports `hosts/common/default.nix` + hardware config
  - `hosts/common/default.nix` imports all `modules/*/desktop.nix` files
- **Server** (`hosts/server`): directly imports `modules/*/server.nix` + hardware config

### System Modules (`modules/`)
Each category has `desktop.nix` and/or `server.nix`:
- `audio/` - PipeWire (desktop only)
- `boot/` - Bootloader (lanzaboote/secure boot)
- `containers/` - OCI containers (adguard-home on server; desktop variant also exists)
- `desktop/` - Desktop environment (niri compositor, Firefox, printing, Sunshine)
- `flatpak/` - Flatpak support (desktop only)
- `gaming/` - Steam, WiVRn, SlimeVR, ALVR (desktop only)
- `hardware/` - NVIDIA drivers, swap, mounts, pen tablet
- `locale/` - Locale, fonts, input methods
- `networking/` - Network config, Cloudflared, Tailscale
- `system/` - Core nix settings, nh, nix-ld, 1Password, packages
- `users/` - User account definitions
- `virtualization/` - Docker

### Home Manager (`home/`)
- Desktop home: `home/default.nix` → imports from `home/programs/`
- Server home: `home/server.nix` → imports from `home/programs/packages-server.nix`
- Desktop programs: git, files, packages, vscode, noctalia, niri, cursor, nushell, nixvim, obs, immich_backups
- nixvim config is split: `home/programs/nixvim/` (colorscheme, keymaps, lsp, opts, plugins)

### Custom Packages (`packages/`)
- `packages/default.nix`: NixOS module that loads overlays
- `packages/overlays/default.nix`: Auto-loads all `.nix` files in `overlays/` as nixpkgs overlays using `nixpkgs.overlays`
- Each overlay file (e.g., `wivrn.nix`, `vpm-cli.nix`, `creator-companion-tui.nix`) is a `callPackage`-compatible function; the package name is derived from the filename

### Cursor Themes (`cursors/`)
Custom cursor packages (`chiffon.nix`, `milk.nix`) used in home configuration.

## Adding New Modules

### System Module
1. Create `modules/new-feature/desktop.nix` (and/or `server.nix`)
2. Add to imports in `hosts/common/default.nix` (desktop) or `hosts/server/default.nix` (server)
3. Available args: `pkgs`, `pkgs-unstable`, `self`, `inputs`, `hostMeta`

### Home Manager Module
1. Create `home/programs/new-program.nix`
2. Add to imports in `home/default.nix`
3. Available args: `pkgs`, `pkgs-unstable`, `pkgs-with-llm-agents`, `inputs`, `hostMeta`

### Custom Package / Overlay
1. Create `packages/overlays/new-package.nix` as a standard `callPackage` function
2. It is automatically picked up — no manual registration needed

## Important Notes

- System and Home Manager state version: 25.11
- Experimental features enabled: `nix-command`, `flakes`
- `allowUnfree = true` for stable, unstable, and llm-agents package sets
- Primary user: `akazdayo`; default architecture: `x86_64-linux`
- `nh` is configured with `clean.enable = true` (keeps 4 days / 3 generations); `flake` points to `hostMeta.flakeRoot` (`/home/akazdayo/configs` by default)
