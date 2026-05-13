{ config, pkgs, self, ... }:
{
  sops = {
    age = {
      sshKeyPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];
      generateKey = false;
      plugins = with pkgs; [ age-plugin-yubikey ];
    };

    # Add secrets here after creating the encrypted file.
    # Example:
    # secrets.immich-api-key = {
    #   sopsFile = "${self}/secrets/nixos/home.yaml";
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
