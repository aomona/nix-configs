{ ... }:
{
  containers.immich = {
    autoStart = true;
    privateNetwork = true;
    macvlans = [ "eno1" ];

    config =
      { ... }:
      {
        networking.hostName = "immich";
        networking.interfaces.mv-eno1 = {
          useDHCP = false;
          ipv4.addresses = [
            {
              address = "192.168.11.61";
              prefixLength = 24;
            }
          ];
        };
        networking.defaultGateway = "192.168.11.1";
        networking.nameservers = [ "1.1.1.1" ];

        services.immich = {
          enable = true;
          host = "0.0.0.0";
          openFirewall = true;
          settings.server.externalDomain = "http://192.168.11.61:2283";
        };

        system.stateVersion = "25.11";
      };
  };
}
