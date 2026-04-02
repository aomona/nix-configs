{ inputs, ... }:
{
  imports = [
    ./programs/git.nix
    ./programs/nushell.nix
    ./programs/nixvim
    ./programs/packages.nix
  ];
  home.stateVersion = "25.11";
}
