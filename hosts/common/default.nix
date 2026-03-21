{ ... }:
{
  imports = [
    ../../modules/boot
    ../../modules/system
    ../../modules/networking
    ../../modules/locale
    ../../modules/desktop
    ../../modules/hardware
    ../../modules/audio
    ../../modules/users
    ../../modules/gaming
    ../../modules/virtualization
    ../../modules/flatpak
  ];

  system.stateVersion = "25.11";
}
