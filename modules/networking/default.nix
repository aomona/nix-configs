{ hostMeta, ... }:
{
  imports = [
    ./tailscale.nix
    ./cloudflared.nix
    ./vpn.nix
  ];

  networking.hostName = hostMeta.hostName;
  networking.nameservers = [ "192.168.11.62" ];
  networking.networkmanager.enable = true;
  services.nscd.enableNsncd = true;

  # SSH
  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };
}
