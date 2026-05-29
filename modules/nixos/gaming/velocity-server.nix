{
  inputs,
  hostMeta,
  pkgs,
  ...
}:
let
  velocityData = hostMeta.hostData.velocity or { };
  minecraftData = hostMeta.hostData.minecraft or { };

  # Shared secret for Velocity modern forwarding.
  # Must match the value on all Fabric backend servers (minecraft host).
  # FIXME: Migrate to sops-nix for production use.
  velocitySecret = velocityData.secret or "changeme-please-replace-at-deploy-time";

  # Internal address of the minecraft backend host
  minecraftInternalIp = minecraftData.internalIp or (throw "hostData.minecraft.internalIp must be set");

  # Velocity binds here for external players
  proxyPort = velocityData.serverPort or 25565;
in
{
  imports = [ inputs.minecraft-nix.nixosModules.minecraft-servers ];

  nixpkgs.overlays = [ inputs.minecraft-nix.overlay ];

  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;

    servers.velocity = {
      enable = true;
      autoStart = true;

      package = pkgs.velocityServers.velocity;
      jvmOpts = velocityData.jvmOpts or "-Xms512M -Xmx1G";

      # Velocity uses "end" rather than "stop" to shut down cleanly
      stopCommand = "end";

      # Velocity does not use Minecraft server.properties
      serverProperties = { };

      # Generate velocity.toml declaratively
      symlinks."velocity.toml" = {
        value = {
          bind = "0.0.0.0:${toString proxyPort}";
          motd = "&#x00a7bNixOS Minecraft Network";
          show-max-players = 500;
          online-mode = true;
          player-info-forwarding-mode = "MODERN";

          servers = {
            smp = "${minecraftInternalIp}:${toString (minecraftData.smp.serverPort or 25566)}";
            creative = "${minecraftInternalIp}:${toString (minecraftData.creative.serverPort or 25568)}";
            try = [ "smp" ];
          };

          forced-hosts = { };

          advanced = {
            compression-level = 1;
          };

          forwarding = {
            secret = velocitySecret;
          };
        };
        format = pkgs.formats.toml { };
      };
    };
  };
}
