{ ... }:
let
  hostDataRoot = "/var/lib/immich-container";
in
{
  systemd.tmpfiles.rules = [
    "d ${hostDataRoot} 0755 root root -"
    "d ${hostDataRoot}/media 0755 root root -"
    "d ${hostDataRoot}/postgresql 0755 root root -"
    "d ${hostDataRoot}/redis 0755 root root -"
    "d ${hostDataRoot}/cache 0755 root root -"
  ];

  containers.immich = {
    autoStart = true;
    privateNetwork = true;
    macvlans = [ "eno1" ];
    bindMounts = {
      "/var/lib/immich" = {
        hostPath = "${hostDataRoot}/media";
        isReadOnly = false;
      };
      "/var/lib/postgresql" = {
        hostPath = "${hostDataRoot}/postgresql";
        isReadOnly = false;
      };
      "/var/lib/redis-immich" = {
        hostPath = "${hostDataRoot}/redis";
        isReadOnly = false;
      };
      "/var/cache/immich" = {
        hostPath = "${hostDataRoot}/cache";
        isReadOnly = false;
      };
    };

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
