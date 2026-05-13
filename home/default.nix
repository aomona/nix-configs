{inputs, ...}: {
  imports = [
    inputs.noctalia.homeModules.default
    inputs.sops-nix.homeManagerModules.default
    ./programs/git.nix
    ./programs/ssh.nix
    ./programs/files.nix
    ./programs/flameshot.nix
    ./programs/packages.nix
    ./programs/vscode.nix
    ./programs/noctalia.nix
    ./programs/niri.nix
    ./programs/cursor.nix
    ./programs/nushell.nix
    ./programs/nixvim
    ./programs/obs.nix
    ./programs/immich_backups.nix
    ./programs/secrets.nix
  ];
  home.stateVersion = "25.11";
}
