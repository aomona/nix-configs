{...}: {
  imports = [
    ./programs/git.nix
    ./programs/files.nix
    ./programs/packages.nix
    ./programs/hyprland.nix
    ./programs/cursor.nix
  ];
  home.stateVersion = "25.11";
}
