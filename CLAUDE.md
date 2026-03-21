# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a modular NixOS configuration using Flakes and Home Manager for user "akazdayo". The configuration is structured for multiple hosts with a clear separation between shared system-level modules (`modules/`), host composition (`hosts/`), and user-level settings (`home/`).

## Common Commands

### Build and Apply Configuration
```bash
# Apply configuration and switch (most common)
sudo nixos-rebuild switch --flake .#nixos

# Test configuration without making it default boot option
sudo nixos-rebuild test --flake .#nixos

# Dry build to check for errors without applying
nixos-rebuild dry-build --flake .#nixos

# Check flake for issues
nix flake check
```

### Updating Dependencies
```bash
# Update all flake inputs
nix flake update

# Update specific input (e.g., nixpkgs or nixpkgs-unstable)
nix flake lock --update-input nixpkgs
nix flake lock --update-input nixpkgs-unstable
```

## Architecture

### Flake Structure
- Uses two nixpkgs inputs: `nixpkgs` (25.11 stable) and `nixpkgs-unstable`
- The flake passes `pkgs-unstable` as `specialArgs` to both NixOS modules and Home Manager
- Host configurations are generated from metadata in `flake.nix`
- `allowUnfree = true` is configured for unstable packages in the flake

### Module Organization
The configuration follows a modular pattern where:

1. **Flake Entry Point**: `flake.nix` generates `nixosConfigurations.<host>` from host metadata
2. **Shared Host Layer**: `hosts/common/default.nix` imports shared system modules from `modules/`
3. **Host Configuration**: `hosts/<host>/default.nix` imports `../common` and host-specific hardware/configuration
3. **System Modules** (`modules/`): Feature-based organization
   - `audio/` - PipeWire configuration
   - `boot/` - Bootloader settings
   - `desktop/` - Desktop environment configuration
   - `gaming/` - Steam, VR (WiVRn), and SlimeVR configurations
   - `hardware/` - NVIDIA drivers (open source), swap configuration
   - `locale/` - Locale, fonts, input methods
   - `networking/` - Network configuration
   - `users/` - User account definitions
   - `virtualization/` - Docker and container configurations

4. **Home Manager** (`home/`): Shared home profile attached to the host's `primaryUser`
   - Configured via flake's `home-manager.nixosModules.home-manager`
   - Uses `useGlobalPkgs = true` and `useUserPackages = true`
   - `home/default.nix` imports programs from `home/programs/`
   - Programs: git, files, packages, hyprland
   - State version: 25.11

5. **Custom Packages** (`packages/default.nix`): Overlays for custom package builds
   - Contains commented WiVRn overlay (currently disabled)

### Multi-File Module Pattern
Some modules use a parent `default.nix` that imports sub-modules:
- `modules/gaming/default.nix` imports `steam.nix`, `wivrn.nix`, `slimevr.nix`
- `modules/virtualization/default.nix` imports `docker.nix`

## Adding New Modules

### System Module
1. Create `modules/new-feature/default.nix`
2. Add to imports in `hosts/common/default.nix` for shared modules, or `hosts/<host>/default.nix` for host-only modules
3. Module receives `pkgs`, `pkgs-unstable`, and `self` as available arguments

### Home Manager Module
1. Create `home/programs/new-program.nix`
2. Add to imports in `home/default.nix`
3. Module receives `pkgs` and `pkgs-unstable` as available arguments

## Important Notes

- System state version: 25.11
- Home Manager state version: 25.11
- Experimental features enabled: `nix-command`, `flakes`
- `allowUnfree = true` is configured in the flake imports for stable and unstable package sets
- Primary user default: `akazdayo`
- Architecture: `x86_64-linux`
- System packages: Firefox and nix-ld are enabled at the system level
