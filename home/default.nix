{...}: {
  imports = [
    ./programs/git.nix
    ./programs/files.nix
    ./programs/packages.nix
    ./programs/hyprland.nix
  ];
  home.stateVersion = "25.11";
}
