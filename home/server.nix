{ inputs, ... }:
{
  imports = [
    ./programs/git.nix
    ./programs/nushell.nix
    ./programs/nixvim
    ./programs/packages-server.nix
  ];
  home.stateVersion = "25.11";
}
