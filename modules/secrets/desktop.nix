{ pkgs, ... }:
{
  services.pcscd.enable = true;

  environment.systemPackages = with pkgs; [
    age-plugin-yubikey
    age
    sops
    ssh-to-age
  ];

  sops = {
    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      generateKey = false;
      plugins = with pkgs; [ age-plugin-yubikey ];
    };

    secrets.immich-api-key = {
      sopsFile = ../../secrets/nixos/home.yaml;
      owner = "akazdayo";
      mode = "0400";
    };
  };
}
