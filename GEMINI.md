# Gemini Context for NixOS Configuration

## Project Overview
This is a modular **NixOS configuration** project using **Flakes**. It manages the system configuration for the host `nixos` and user configuration via **Home Manager**.

- **User:** `akazdayo`
- **Host:** `nixos`
- **System:** `x86_64-linux`
- **NixOS Version:** 25.11 (with `nixos-unstable` available as an overlay).
- **Key Inputs:** `nixpkgs`, `home-manager`, `nixvim`.

## Architecture & Directory Structure

The configuration is highly modularized to separate system-level settings, hardware specifics, and user-level applications.

### Key Files
- **`flake.nix`**: The entry point. Defines inputs (nixpkgs, home-manager, nixvim) and the `nixos` system configuration. It passes `pkgs-unstable` into `specialArgs`.
- **`configuration.nix`**: A wrapper that simply imports `./hosts/nixos`.
- **`hosts/nixos/default.nix`**: The effective `configuration.nix` for the specific host. Imports hardware config and modules.
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
2.  Import the new module in `hosts/nixos/default.nix`.

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
