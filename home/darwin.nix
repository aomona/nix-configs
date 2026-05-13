{ inputs, ... }:
{
  imports = [
    inputs.sops-nix.homeManagerModules.default
    ./programs/git.nix
    ./programs/ssh.nix
    ./programs/nushell.nix
    ./programs/nixvim
    ./programs/packages-darwin.nix
    ./programs/secrets.nix
  ];

  home.stateVersion = "25.11";
}
