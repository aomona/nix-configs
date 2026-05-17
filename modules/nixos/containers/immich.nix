{ hostMeta, ... }:
let
  containerData = hostMeta.hostData.containers;
  immichData = containerData.immich;
  hostDataRoot = immichData.hostDataRoot;
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
    macvlans = [ containerData.hostInterface ];
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
        networking.hostName = immichData.hostName;
        networking.interfaces.${containerData.containerInterface} = {
          useDHCP = false;
          ipv4.addresses = [
            {
              address = immichData.address;
              prefixLength = immichData.prefixLength;
            }
          ];
        };
        networking.defaultGateway = containerData.defaultGateway;
        networking.nameservers = containerData.nameservers;

        services.immich = {
          enable = true;
          host = "0.0.0.0";
          openFirewall = true;
          settings.server.externalDomain = immichData.externalDomain;
        };

        system.stateVersion = "25.11";
      };
  };
}
