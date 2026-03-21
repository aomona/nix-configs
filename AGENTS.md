# AGENTS.md

## Build & Test Commands
- **Apply Config**: `sudo nixos-rebuild switch --flake .#nixos` (replace `nixos` with another host as needed)
- **Test Config**: `sudo nixos-rebuild test --flake .#nixos`
- **Dry Run**: `nixos-rebuild dry-build --flake .#nixos`
- **Lint/Check**: `nix flake check`

## Code Style & Conventions
- **Structure**: Modular Flake config. System settings in `modules/`, user settings in `home/`.
- **Modules**: Use `default.nix` as directory entry point. Import sub-modules in `default.nix`.
- **Arguments**: Modules typically accept `{ pkgs, pkgs-unstable, ... }`. Host-aware modules may also receive `hostMeta`.
- **Registration**:
  - Shared system modules: Add to imports in `hosts/common/default.nix`.
  - Host-only system modules: Add to imports in `hosts/<host>/default.nix`.
  - Home Manager modules: Add to imports in `home/default.nix`.
- **Formatting**: Standard Nix formatting. Prefer clarity and modularity.
- **Versions**: Maintain `system.stateVersion = "25.11"` and `home.stateVersion = "25.11"`.
- **Packages**: Use `pkgs-unstable` for newer software if needed (passed via specialArgs).

## Strict File & Directory Rules
- **Directory Boundaries**:
  - `hosts/<host>/default.nix`: Host composition and module imports only. Avoid direct feature settings whenever possible.
  - `modules/`: NixOS system settings only.
  - `home/`: Home Manager user settings only.
  - `packages/`: overlays and derivations only.
  - `dotfiles/`: static files only (no Nix option definitions).
- **Entry Points**:
  - Use `default.nix` as the directory entry point.
  - `default.nix` should primarily import child modules; keep concrete settings there minimal.
- **Single Responsibility**:
  - Keep one primary concern per file.
  - Match file name to primary option group (example: `packages.nix` manages `home.packages`).
  - Do not mix unrelated domains in one file (example: desktop/locale/networking split).
- **Naming**:
  - New file and directory names must use lowercase kebab-case.
- **Import Registration**:
  - New shared system modules must be wired through a parent `default.nix` and imported from `hosts/common/default.nix`.
  - Host-only modules stay in `hosts/<host>/default.nix`.
  - New Home Manager modules must be imported from `home/default.nix`.
- **Security (Principle with Exceptions)**:
  - Principle: Do not hardcode secrets (API keys, tokens, passwords) in tracked files.
  - Exception: Local-only non-privileged values may be temporarily allowed when unavoidable.
  - When using an exception, document reason and scope inline, and plan migration to secret management or environment variables.
