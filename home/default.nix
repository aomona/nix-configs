{...}: {
  imports = [
    ./programs/git.nix
    ./programs/files.nix
    ./programs/packages.nix
    ./programs/hyprland.nix
    ./programs/cursor.nix
    ./programs/nushell.nix
  ];
  home.stateVersion = "25.11";
}
