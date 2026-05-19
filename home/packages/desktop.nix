{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nextcloud-client
    xdg-utils
    slack
    ghostty
    libreoffice
    signal-desktop
    termius
    tor-browser
    google-chrome
    nautilus
    code-cursor
    unar
    nostui
    obsidian
    zoom-us
    vesktop
  ];
}
