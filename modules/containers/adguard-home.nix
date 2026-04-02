{ ... }:
{
  containers.adguard-home = {
    autoStart = true;
    privateNetwork = true;
    macvlans = [ "eno1" ];

    config =
      { ... }:
      {
        networking.interfaces.mv-eno1 = {
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
          host = "0.0.0.0";
          port = 3000;
          settings = {
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
