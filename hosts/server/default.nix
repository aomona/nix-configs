{ ... }:
{
  imports = [
    ../../modules/boot/server.nix
    ../../modules/system/server.nix
    ../../modules/networking/server.nix
    ../../modules/locale/server.nix
    ../../modules/users/server.nix
    ../../modules/virtualization/server.nix
    ../../modules/containers/server.nix
    ../../modules/gaming/minecraft-server.nix
    ../../modules/bitcoin
    ./hardware-configuration.nix
  ];

  system.stateVersion = "25.11";
}
