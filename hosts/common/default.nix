{ ... }:
{
  imports = [
    ../../modules/boot/desktop.nix
    ../../modules/system/desktop.nix
    ../../modules/networking/desktop.nix
    ../../modules/locale/desktop.nix
    ../../modules/desktop/desktop.nix
    ../../modules/hardware/desktop.nix
    ../../modules/audio/desktop.nix
    ../../modules/users/desktop.nix
    ../../modules/gaming/desktop.nix
    ../../modules/virtualization/desktop.nix
    ../../modules/flatpak/desktop.nix
  ];

  system.stateVersion = "25.11";
}
