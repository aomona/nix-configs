{ ... }:

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
      HiddenServiceDir = "/var/lib/tor/bitcoin-node";
      HiddenServicePort = "8333 192.168.100.11:8333";
    };
  };

  # Ensure hidden service directory exists with correct permissions
  systemd.tmpfiles.rules = [
    "d /var/lib/tor/bitcoin-node 0700 tor tor -"
  ];
}
