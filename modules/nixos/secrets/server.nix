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

    # Server-level sops integration is configured here, but current
    # container /etc/... secret files remain legacy host-local paths.
  };
}
