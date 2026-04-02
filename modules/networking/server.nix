{ hostMeta, ... }:
{
  imports = [
    ./tailscale.nix
    ./cloudflared.nix
  ];

  networking.hostName = hostMeta.hostName;
  networking.nameservers = [ "192.168.11.50" ];
  networking.networkmanager.enable = true;
  networking.networkmanager.unmanaged = [ "eno1" ];

  networking.interfaces.eno1 = {
    useDHCP = false;
    ipv4.addresses = [{
      address = "192.168.11.50";
      prefixLength = 24;
    }];
  };
  networking.defaultGateway = "192.168.11.1";
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
