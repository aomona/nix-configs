# Gemini Context for NixOS Configuration

## Project Overview
This is a modular **NixOS configuration** project using **Flakes**. It manages multiple host configurations from one repository and attaches shared **Home Manager** settings to each host's primary user.

- **User:** `akazdayo`
- **Current host:** `nixos`
- **System:** `x86_64-linux`
- **NixOS Version:** 25.11 (with `nixos-unstable` available as an overlay).
- **Key Inputs:** `nixpkgs`, `home-manager`, `nixvim`.

## Architecture & Directory Structure

The configuration is highly modularized to separate system-level settings, hardware specifics, and user-level applications.

### Key Files
- **`flake.nix`**: The entry point. Defines inputs and generates `nixosConfigurations.<host>` from host metadata. It passes `pkgs-unstable` and `hostMeta` into modules.
- **`hosts/common/default.nix`**: Shared NixOS module composition for all hosts.
- **`hosts/nixos/default.nix`**: The current host definition. Imports shared modules and host-specific hardware config.
- **`home/default.nix`**: The entry point for Home Manager configuration.

### Directory Breakdown
- **`modules/`**: Contains reusable system-level modules grouped by category (e.g., `audio`, `desktop`, `hardware`, `gaming`).
- **`home/`**: Contains Home Manager configurations.
    - `programs/`: Individual program configurations (e.g., `git.nix`, `hyprland.nix`, `nixvim.nix`).
- **`packages/`**: Custom package definitions or overrides.
- **`dotfiles/`**: Static configuration files (referenced by Nix modules).
- **`wallpapers/`**: Asset directory.

## Building and Management

### Applying Configuration
To rebuild the system and switch to the new configuration:
```bash
sudo nixos-rebuild switch --flake .#nixos
```

### Testing Configuration
To test without modifying the bootloader:
```bash
sudo nixos-rebuild test --flake .#nixos
```

### Flake Maintenance
To update the flake lockfile:
```bash
nix flake update
```

## Development Conventions

### Adding New System Features
1.  Create a new module in `modules/<category>/<feature>.nix` (or `default.nix` in a subdirectory).
2.  Import the new module in `hosts/common/default.nix` for shared features, or `hosts/<host>/default.nix` for host-only features.

### Adding User/Home Manager Features
1.  Create a new configuration file in `home/programs/<feature>.nix`.
2.  Import the new file in `home/default.nix`.

### Using Unstable Packages
The `flake.nix` passes `pkgs-unstable` as a special argument. Use it in modules like this:
```nix
{ config, pkgs, pkgs-unstable, ... }: {
  environment.systemPackages = [
    pkgs-unstable.some-package
  ];
}
```

### Nixvim
Neovim is configured using `nixvim` (via `home-manager` module). Configuration likely resides in `home/programs/nixvim.nix`.
