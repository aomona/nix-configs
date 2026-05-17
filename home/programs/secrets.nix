{ config, pkgs, ... }:
{
  sops = {
    age = {
      sshKeyPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];
      generateKey = false;
      plugins = with pkgs; [ age-plugin-yubikey ];
    };

    # Home Manager imports this module on desktop/server/darwin, but there are
    # no active HM-managed secrets yet. Keep examples aligned to current paths.
    # Example:
    # secrets.immich-api-key = {
    #   sopsFile = ../../secrets/nixos/home.yaml;
    #   path = "%r/immich-api-key";
    # };
  };

  home.packages = with pkgs; [
    sops
    age
    age-plugin-yubikey
    ssh-to-age
  ];
}
