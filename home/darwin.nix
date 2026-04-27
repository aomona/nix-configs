{ ... }:
{
  imports = [
    ./programs/git.nix
    ./programs/ssh.nix
    ./programs/nushell.nix
    ./programs/nixvim
    ./programs/packages-darwin.nix
  ];

  home.stateVersion = "25.11";
}
