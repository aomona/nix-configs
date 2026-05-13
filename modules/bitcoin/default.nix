{ config, ... }:

{
  # NixOS container running Bitcoin Core pruned node
  containers.bitcoin = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "192.168.100.10";
    localAddress = "192.168.100.11";

    config = { ... }: {
      system.stateVersion = "25.11";

      services.bitcoind.main = {
        enable = true;
        extraConfig = ''
          prune=10000
          proxy=192.168.100.10:9050
          listen=1
          bind=0.0.0.0
          discover=0
        '';
      };

      networking.firewall.allowedTCPPorts = [ 8333 ];
    };
  };

  # Tor proxy and hidden service for external P2P exposure
  services.tor = {
    enable = true;
    settings = {
      SocksPort = [
        "127.0.0.1:9050"
        "192.168.100.10:9050"
      ];
    };
    relay.onionServices."bitcoin-node" = {
      version = 3;
      #secretKey = config.sops.secrets.tor-bitcoin-node-key.path;
      map = [{
        port = 8333;
        target = {
          addr = "192.168.100.11";
          port = 8333;
        };
      }];
    };
  };
}
