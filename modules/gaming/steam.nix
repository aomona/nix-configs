{ pkgs, pkgs-unstable, ... }:
{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    extraCompatPackages = [
      pkgs-unstable.proton-ge-bin
      pkgs.proton-ge-rtsp-bin
    ];
  };
}
