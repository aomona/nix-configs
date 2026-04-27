{ hostMeta, ... }:
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = hostMeta.system;

  system.primaryUser = hostMeta.primaryUser;
  system.stateVersion = 6;

  users.users.${hostMeta.primaryUser}.home = "/Users/${hostMeta.primaryUser}";
}
