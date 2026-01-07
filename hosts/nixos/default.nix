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

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/akazdayo/configs/"; # sets NH_OS_FLAKE variable for you
  };

  services.printing.enable = true;

  services.tailscale.enable = true;

  services.cloudflared = {
    enable = true;
  };

  services.sunshine = {
    enable=true;
    autoStart=false;
    openFirewall=true;
    capSysAdmin=true;
  };
  environment.systemPackages = with pkgs; [
    vim
  ];

  system.stateVersion = "25.11";
}
