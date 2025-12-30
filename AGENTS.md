# AGENTS.md

## Build & Test Commands
- **Apply Config**: `sudo nixos-rebuild switch --flake .#nixos`
- **Test Config**: `sudo nixos-rebuild test --flake .#nixos`
- **Dry Run**: `nixos-rebuild dry-build --flake .#nixos`
- **Lint/Check**: `nix flake check`

## Code Style & Conventions
- **Structure**: Modular Flake config. System settings in `modules/`, user settings in `home/`.
- **Modules**: Use `default.nix` as directory entry point. Import sub-modules in `default.nix`.
- **Arguments**: Modules typically accept `{ pkgs, pkgs-unstable, ... }`.
- **Registration**:
  - System modules: Add to imports in `hosts/nixos/default.nix`.
  - Home Manager modules: Add to imports in `home/default.nix`.
- **Formatting**: Standard Nix formatting. Prefer clarity and modularity.
- **Versions**: Maintain `system.stateVersion = "25.05"` and `home.stateVersion = "25.11"`.
- **Packages**: Use `pkgs-unstable` for newer software if needed (passed via specialArgs).
