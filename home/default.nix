{ inputs, ... }:
{
  imports = [
    inputs.noctalia.homeModules.default
    ./programs/git.nix
    ./programs/files.nix
    ./programs/packages.nix
    ./programs/noctalia.nix
    ./programs/niri.nix
    ./programs/cursor.nix
    ./programs/nushell.nix
    ./programs/nixvim
    ./programs/obs.nix
    ./programs/immich_backups.nix
  ];
  home.stateVersion = "25.11";
}
