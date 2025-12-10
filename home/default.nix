{...}: {
  imports = [
    ./programs/git.nix
    ./programs/files.nix
    ./programs/packages.nix
    ./programs/hyprland.nix
    # ./programs/vr.nix
  ];
  home.stateVersion = "25.11";
}
