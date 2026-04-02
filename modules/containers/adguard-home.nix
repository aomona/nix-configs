{ ... }:
{
  networking.macvlans.mv-adguard = {
    interface = "eno1";
    mode = "bridge";
  };

  containers.adguard-home = {
    autoStart = true;
    privateNetwork = true;
    interfaces = [ "mv-adguard" ];

    config =
      { ... }:
      {
        networking.interfaces.mv-adguard = {
          useDHCP = false;
          ipv4.addresses = [
            {
              address = "192.168.11.62";
              prefixLength = 24;
            }
          ];
        };
        networking.defaultGateway = "192.168.11.1";
        networking.nameservers = [ "1.1.1.1" ];

        services.adguardhome = {
          enable = true;
          settings = {
            bind_host = "0.0.0.0";
            bind_port = 3000;
            dns = {
              bind_hosts = [ "0.0.0.0" ];
              port = 53;
            };
          };
        };

        networking.firewall = {
          allowedTCPPorts = [
            53
            80
            443
            3000
          ];
          allowedUDPPorts = [ 53 ];
        };

        system.stateVersion = "25.11";
      };
  };
}
