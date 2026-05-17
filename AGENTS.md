# AGENTS.md

## Build & Test Commands
- **Apply Config (NixOS)**: `sudo nixos-rebuild switch --flake .#nixos` (replace `nixos` with `server` as needed)
- **Test Config (NixOS)**: `sudo nixos-rebuild test --flake .#nixos`
- **Dry Run (NixOS)**: `nixos-rebuild dry-build --flake .#nixos`
- **Apply Config (Darwin)**: `nix run nix-darwin -- switch --flake .#macbook`
- **Lint/Check**: `nix flake check`

## Code Style & Conventions
- **Structure**: Platform-first modular Flake. System settings live under `modules/<platform>/`, user settings under `home/`.
- **Modules**: Use `default.nix` as directory entry point. Import sub-modules in `default.nix`.
- **Arguments**: Modules typically accept `{ pkgs, pkgs-unstable, ... }`. Host-aware modules may also receive `hostMeta`.
- **Registration**:
  - NixOS system modules: imported by `profiles/nixos/*.nix`.
  - Darwin system modules: imported by `profiles/darwin/*.nix`.
  - Cross-platform modules: imported by `modules/shared/default.nix` (currently a placeholder).
  - Home Manager modules: imported by `home/profiles/*.nix`.
- **Formatting**: Standard Nix formatting. Prefer clarity and modularity.
- **Versions**: Maintain `system.stateVersion = "25.11"` (NixOS) and `home.stateVersion = "25.11"`. Darwin hosts use integer `system.stateVersion` (for example, `6`).
- **Packages**: Use `pkgs-unstable` for newer software if needed (passed via `specialArgs`).

## Strict File & Directory Rules
- **Directory Boundaries**:
  - `hosts/<host>/default.nix`: Host composition only. Must be a thin wrapper importing a profile, hardware config, and `host-data.nix`. No direct feature settings.
  - `hosts/<host>/host-data.nix`: Host-local literals only (network addresses, interfaces, mount paths, swap path, SSH authorized keys, container paths). No reusable module logic.
  - `modules/nixos/`: NixOS system settings only.
  - `modules/darwin/`: Darwin system settings only.
  - `modules/shared/`: Cross-platform modules only. Must be safe to evaluate on both NixOS and Darwin. Currently a placeholder.
  - `profiles/nixos/`: NixOS profile aggregators. Each file bundles modules for a host type (desktop, server).
  - `profiles/darwin/`: Darwin profile aggregators.
  - `home/profiles/`: Home Manager profile aggregators. Each file bundles program configs and package groups for a host type.
  - `home/packages/`: Home Manager package groups by purpose. Each file sets `home.packages`.
  - `home/programs/`: Per-program Home Manager configuration.
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
- **Profile Registration**:
  - New NixOS modules must be imported from a `profiles/nixos/*.nix` file, not directly from a host entry.
  - New Darwin modules must be imported from a `profiles/darwin/*.nix` file.
  - New Home Manager profiles must be imported from `home/profiles/*.nix`.
  - New package groups must be imported from the relevant `home/profiles/*.nix`.
- **Host-Local Data**:
  - Static host values (IP addresses, interface names, gateway, DNS, mount paths, swap file path, SSH authorized keys, Immich paths/URLs, container service paths) belong in `hosts/<host>/host-data.nix`.
  - Reusable modules must read these values from `hostMeta.hostData`, never hardcode them.
- **Security (Principle with Exceptions)**:
  - Principle: Do not hardcode secrets (API keys, tokens, passwords) in tracked files.
  - Exception: Local-only non-privileged values may be temporarily allowed when unavoidable.
  - When using an exception, document reason and scope inline, and plan migration to secret management or environment variables.
- **Secret Path Freeze**:
  - Do not move, rename, or rekey tracked encrypted secret files during repo structure work.
  - Current tracked encrypted files: `secrets/nixos/home.yaml`.
  - Other `secrets/` subdirectories contain only `.gitkeep` placeholders.
  - Legacy container secret paths (`/etc/nextcloud-adminpass`, `/etc/searx-env`) remain host-local files. Do not migrate them to sops-nix without an explicit task.
