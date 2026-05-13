{ inputs, ... }:
{
  imports = [
    inputs.sops-nix.homeManagerModules.default
    ./programs/git.nix
    ./programs/nushell.nix
    ./programs/nixvim
    ./programs/packages-server.nix
    ./programs/secrets.nix
  ];
  home.stateVersion = "25.11";
}
