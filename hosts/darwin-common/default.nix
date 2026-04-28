{ hostMeta, ... }:
{
  imports = [
    ../../modules/boot/darwin.nix
    ../../modules/system/darwin.nix
    ../../modules/networking/darwin.nix
    ../../modules/locale/darwin.nix
    ../../modules/desktop/darwin.nix
    ../../modules/hardware/darwin.nix
    ../../modules/audio/darwin.nix
    ../../modules/users/darwin.nix
    ../../modules/gaming/darwin.nix
    ../../modules/virtualization/darwin.nix
    ../../modules/flatpak/darwin.nix
    ../../modules/containers/darwin.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.always-allow-substitutes = true;
  nix.settings.extra-trusted-substituters = [
    "https://cache.lix.systems"
  ];
  nix.settings.extra-trusted-public-keys = [
    "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = hostMeta.system;

  environment.systemPath = [
    "/opt/homebrew/bin"
  ];

  system.primaryUser = hostMeta.primaryUser;
  system.stateVersion = 6;

  users.users.${hostMeta.primaryUser}.home = "/Users/${hostMeta.primaryUser}";
}
