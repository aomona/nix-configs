{ pkgs, ... }:
{
  imports = [
    ../../hardware-configuration.nix
    ../../modules/boot
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

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;

  programs.firefox.enable = true;

  programs.nix-ld.enable = true;

  services.printing.enable = true;

  services.cloudflared = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    vim
  ];

  system.stateVersion = "25.11";
}
