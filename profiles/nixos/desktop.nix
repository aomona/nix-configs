{ ... }:
{
  imports = [
    ../../modules/nixos/boot/desktop.nix
    ../../modules/nixos/system/desktop.nix
    ../../modules/nixos/networking/desktop.nix
    ../../modules/nixos/locale/desktop.nix
    ../../modules/nixos/desktop/desktop.nix
    ../../modules/nixos/hardware/desktop.nix
    ../../modules/nixos/audio/desktop.nix
    ../../modules/nixos/users/desktop.nix
    ../../modules/nixos/gaming/desktop.nix
    ../../modules/nixos/virtualization/desktop.nix
    ../../modules/nixos/flatpak/desktop.nix
    ../../modules/nixos/secrets/desktop.nix
  ];

  system.stateVersion = "25.11";
}
