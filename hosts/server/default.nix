{ ... }:
{
  imports = [
    ../../modules/boot
    ../../modules/system
    ../../modules/networking
    ../../modules/locale
    ../../modules/users
    ../../modules/virtualization
    ./hardware-configuration.nix
  ];

  system.stateVersion = "25.11";
}
