{...}: {
  imports = [
    ./programs/git.nix
    ./programs/files.nix
    ./programs/packages.nix
    # ./programs/vr.nix
  ];
  home.stateVersion = "25.11";
}
