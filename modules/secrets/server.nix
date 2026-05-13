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

    secrets.tor-bitcoin-node-key = {
      format = "binary";
      sopsFile = ../../secrets/server/tor-bitcoin-node-key;
      owner = "tor";
      group = "tor";
      mode = "0400";
    };
  };
}
