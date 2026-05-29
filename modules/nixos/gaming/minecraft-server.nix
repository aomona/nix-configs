{
  inputs,
  hostMeta,
  pkgs,
  ...
}:
let
  minecraftData = hostMeta.hostData.minecraft or { };

  # Shared secret for Velocity modern forwarding.
  # Must match the value on the gateway host (velocity-server).
  # FIXME: Migrate to sops-nix for production use.
  velocitySecret = minecraftData.velocitySecret or "changeme-please-replace-at-deploy-time";

  # === Minecraft Version & Package ===
  # All fabric backend servers share the same MC version / fabric loader
  fabricPackage = (pkgs.fabricServers.fabric-26_1_2.override { jre_headless = pkgs.jdk25; });

  # === Common Mods (shared by all fabric backend servers) ===
  commonMods = {
    FabricApi = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/E1mjhYMF/fabric-api-0.150.0%2B26.1.2.jar";
      sha512 = "238c793b720ed21d2d5b564eca88c714cf2188f7b0fb1fd30864660f80901e2b4dad273994b6f77de3c0aa365f930ed8aaccffac49b36c6456b153b52d5d21dc";
    };
    Lithium = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/Nt50x0fz/lithium-fabric-0.24.3%2Bmc26.1.2.jar";
      sha512 = "b6f948576b062f83f1b13033c3f1121a3d4add8f8294415f8d283caeb91ca28acc1e19fb021a8807a034ff9875ef0dd9b6054734d552e072336aa060a106044f";
    };
    Carpet = pkgs.fetchurl {
      # https://github.com/gnembon/fabric-carpet/releases
      url = "https://github.com/gnembon/fabric-carpet/releases/download/v26.1/fabric-carpet-26.1+v260402.jar";
      sha256 = "59bd225d12423a7d7a635ca0c94fa786f97ccebb116922b16d76072da4ee67e7";
    };
    Servux = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/zQhsx8KF/versions/eu63Kj9A/servux-fabric-26.1.2-0.10.2.jar";
      sha512 = "78566cebcc5e181c68fc7f78c2f34213d634ae930f82cdfad19dd65ac4e6b24ae6d541a200b069e07e32e90b5c827d1cc1e80809da376bfbabfc8b302f9f256a";
    };
    Vivecraft = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/wGoQDPN5/versions/dAFnGtKk/vivecraft-26.1.2-1.3.8-fabric.jar";
      sha512 = "3228489a2ff1191d90a47c0a50d11aa19c6a818032c8657bd530e7c1fbd7cdfca5c2e3062c9da2de868407b83e94f16c57bc44d4537d9538b08f1d9f584037a9";
    };
    FabricProxyLite = pkgs.fetchurl {
      url = "https://github.com/OKTW-Network/FabricProxy-Lite/releases/download/v2.12.0/FabricProxy-Lite-2.12.0.jar";
      sha256 = "dca0d05685afaa25d554372ad118d90b6b27f85ded93e6db0b85d822aa29342a";
    };
  };

  # Derive a linkFarm from the mod attribute set
  modsLink = pkgs.linkFarmFromDrvs "mods" (builtins.attrValues commonMods);

  # Fabric Proxy Lite config (shared by all proxy-aware fabric servers)
  fabricProxyLiteConfig = {
    value = {
      proxySecret = velocitySecret;
      ipHeader = null;
      playersOnForwardingError = "DISCONNECT";
    };
    format = pkgs.formats.json { };
  };

  # Helper: create a fabric server module fragment
  mkFabricServer = serverName: { port, jvmOpts, gamemode, motd, maxPlayers, operators, whitelist }:
    let
      serverData = minecraftData.${serverName} or { };
    in
    {
      enable = true;
      autoStart = true;

      package = fabricPackage;
      jvmOpts = serverData.jvmOpts or jvmOpts;

      serverProperties = {
        server-port = serverData.serverPort or port;
        motd = motd;
        gamemode = gamemode;
        difficulty = "normal";
        max-players = maxPlayers;
        white-list = true;
        online-mode = false;
        enforce-secure-profile = false;
        view-distance = 10;
        simulation-distance = 10;
      };

      inherit whitelist operators;

      symlinks = {
        mods = modsLink;
        "config/fabric-proxy-lite.json" = fabricProxyLiteConfig;
      };
    };
in
{
  imports = [ inputs.minecraft-nix.nixosModules.minecraft-servers ];

  nixpkgs.overlays = [ inputs.minecraft-nix.overlay ];

  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;

    # === Survival Multiplayer (SMP) ===
    servers.fabric-smp = mkFabricServer "smp" {
      port = 25566;
      jvmOpts = "-Xms4G -Xmx8G";
      gamemode = "survival";
      motd = "NixOS Fabric SMP";
      maxPlayers = 20;

      whitelist = {
        aomona = "02992baf-9329-4c6a-b893-3e4b5ce37ca1";
        akaz_dango = "644d4fc6-1525-4426-9eb9-7c7877883e81";
        tokuzou0829 = "67ddca9d-42aa-4522-adc8-ab904eff34cd";
        shu_tti = "379c2f07-08d5-4b0e-9fe6-6fd044723d64";
        t4ko_uwu = "aedb2b9b-2fd3-415b-aa29-bac9a430a618";
        moons14 = "ede38872-25c5-414f-a04e-278b521d9f41";
        fa0311 = "7dfc7f95-df6f-435f-85f4-71513cc8fa87";
        yuta_kobayashi = "cfcc92a7-7b55-4b45-a13f-0eebf716e5f3";
      };

      operators = {
        moons14 = {
          uuid = "ede38872-25c5-414f-a04e-278b521d9f41";
          level = 1;
          bypassesPlayerLimit = false;
        };
        akaz_dango = {
          uuid = "644d4fc6-1525-4426-9eb9-7c7877883e81";
          level = 4;
          bypassesPlayerLimit = true;
        };
      };
    };

    # === Creative Server (same mods as SMP) ===
    servers.fabric-creative = mkFabricServer "creative" {
      port = 25568;
      jvmOpts = "-Xms4G -Xmx8G";
      gamemode = "creative";
      motd = "NixOS Fabric Creative";
      maxPlayers = 20;

      whitelist = {
        aomona = "02992baf-9329-4c6a-b893-3e4b5ce37ca1";
        akaz_dango = "644d4fc6-1525-4426-9eb9-7c7877883e81";
        tokuzou0829 = "67ddca9d-42aa-4522-adc8-ab904eff34cd";
        shu_tti = "379c2f07-08d5-4b0e-9fe6-6fd044723d64";
        t4ko_uwu = "aedb2b9b-2fd3-415b-aa29-bac9a430a618";
        moons14 = "ede38872-25c5-414f-a04e-278b521d9f41";
        fa0311 = "7dfc7f95-df6f-435f-85f4-71513cc8fa87";
        yuta_kobayashi = "cfcc92a7-7b55-4b45-a13f-0eebf716e5f3";
      };

      operators = {
        moons14 = {
          uuid = "ede38872-25c5-414f-a04e-278b521d9f41";
          level = 4;
          bypassesPlayerLimit = true;
        };
        akaz_dango = {
          uuid = "644d4fc6-1525-4426-9eb9-7c7877883e81";
          level = 4;
          bypassesPlayerLimit = true;
        };
      };
    };
  };
}
