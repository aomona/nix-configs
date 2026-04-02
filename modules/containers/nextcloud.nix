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
      { pkgs, ... }:
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
          https = true;
          config = {
            adminuser = "admin";
            adminpassFile = "/run/secrets/nextcloud-adminpass";
            dbtype = "pgsql";
          };
          database.createLocally = true;
        };

        services.nginx = {
          enable = true;
          virtualHosts."192.168.11.63" = {
            sslCertificate = "/var/lib/nextcloud-certs/cert.pem";
            sslCertificateKey = "/var/lib/nextcloud-certs/key.pem";
          };
        };

        systemd.services.generate-nextcloud-cert = {
          description = "Generate self-signed certificate for Nextcloud";
          before = [ "nginx.service" ];
          wantedBy = [ "nginx.service" ];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
          };
          script = '' # すごく無理のある実装でおもろい
            if [ ! -f /var/lib/nextcloud-certs/cert.pem ]; then
              mkdir -p /var/lib/nextcloud-certs
              ${pkgs.openssl}/bin/openssl req -x509 -newkey rsa:4096 \
                -keyout /var/lib/nextcloud-certs/key.pem \
                -out /var/lib/nextcloud-certs/cert.pem \
                -days 3650 -nodes \
                -subj "/CN=192.168.11.63"
              chmod 600 /var/lib/nextcloud-certs/key.pem
              chmod 644 /var/lib/nextcloud-certs/cert.pem
            fi
          '';
        };

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
