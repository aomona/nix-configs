{ ... }:
{
  containers.nextcloud = {
    autoStart = true;
    privateNetwork = true;
    macvlans = [ "eno1" ];
    bindMounts = {
      "/run/secrets/nextcloud-adminpass" = {
        hostPath = "/etc/nextcloud-adminpass";
        isReadOnly = true;
      };
    };

    config =
      { ... }:
      {
        networking.interfaces.mv-eno1 = {
          useDHCP = false;
          ipv4.addresses = [
            {
              address = "192.168.11.63";
              prefixLength = 24;
            }
          ];
        };
        networking.defaultGateway = "192.168.11.1";
        networking.nameservers = [ "1.1.1.1" ];

        services.nextcloud = {
          enable = true;
          hostName = "192.168.11.63";
          https = false;
          config = {
            adminuser = "admin";
            adminpassFile = "/run/secrets/nextcloud-adminpass";
            dbtype = "pgsql";
          };
          database.createLocally = true;
        };

        services.nginx.enable = true;

        networking.firewall = {
          allowedTCPPorts = [
            80
            443
          ];
        };

        system.stateVersion = "25.11";
      };
  };
}
