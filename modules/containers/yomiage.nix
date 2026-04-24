{ pkgs, pkgs-unstable, ... }:
let
  appName = "omni-tts-discord";
  bunPkg = pkgs-unstable.bun;
  appSource = pkgs.fetchFromGitHub {
    owner = "akazdayo";
    repo = "omni-tts-discord";
    rev = "0210b255a010f8e95afa37d4088c9fd10229136b";
    hash = "sha256-f7yYnqHTLqcXH0bn+Tg8YYAGmvT3ltJ/WTExXhz8NI0=";
  };
  sourceRoot = "/mnt/${appName}-source";
  envFile = "/etc/${appName}.env";
  stateDir = "/var/lib/${appName}";
  appRoot = "${stateDir}/app";
  cacheDir = "${stateDir}/cache";
  voiceDataDir = "${stateDir}/voices";
  containerIp = "192.168.11.64";
in
{
  systemd.tmpfiles.rules = [
    "d ${voiceDataDir} 0750 root root -"
  ];

  containers.yomiage = {
    autoStart = true;
    privateNetwork = true;
    macvlans = [ "eno1" ];
    bindMounts = {
      "${sourceRoot}" = {
        hostPath = "${appSource}";
        isReadOnly = true;
      };
      "/run/secrets/${appName}.env" = {
        hostPath = envFile;
        isReadOnly = true;
      };
      "${appRoot}/voices" = {
        hostPath = voiceDataDir;
        isReadOnly = false;
      };
    };

    config =
      { ... }:
      {
        networking.hostName = "yomiage";
        networking.interfaces.mv-eno1 = {
          useDHCP = false;
          ipv4.addresses = [
            {
              address = containerIp;
              prefixLength = 24;
            }
          ];
        };
        networking.defaultGateway = "192.168.11.1";
        networking.nameservers = [ "1.1.1.1" ];

        systemd.tmpfiles.rules = [
          "d ${stateDir} 0750 root root -"
          "d ${appRoot} 0750 root root -"
          "d ${cacheDir} 0750 root root -"
          "d ${cacheDir}/bun 0750 root root -"
          "d ${cacheDir}/uv 0750 root root -"
        ];

        systemd.services.omni-tts-discord-setup = {
          description = "Prepare omni-tts-discord runtime dependencies";
          after = [ "network-online.target" ];
          wants = [ "network-online.target" ];
          before = [
            "omni-tts-discord-api.service"
            "omni-tts-discord-bot.service"
          ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            WorkingDirectory = appRoot;
            TimeoutStartSec = "30min";
          };
          script = ''
            export HOME=${stateDir}
            export BUN_INSTALL_CACHE_DIR=${cacheDir}/bun
            export UV_CACHE_DIR=${cacheDir}/uv

            ${pkgs.rsync}/bin/rsync -a --delete \
              --exclude .git \
              --exclude .direnv \
              --exclude .venv \
              --exclude node_modules \
              --exclude voices \
              ${sourceRoot}/ ${appRoot}/

            ${bunPkg}/bin/bun install --frozen-lockfile
            ${pkgs.uv}/bin/uv sync --python ${pkgs.python314}/bin/python --frozen --no-dev
          '';
        };

        systemd.services.omni-tts-discord-api = {
          description = "omni-tts-discord FastAPI server";
          wants = [ "network-online.target" ];
          after = [
            "network-online.target"
            "omni-tts-discord-setup.service"
          ];
          requires = [ "omni-tts-discord-setup.service" ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            WorkingDirectory = "${appRoot}/packages/server";
            Environment = [
              "HOME=${stateDir}"
              "OMNITTS_DEVICE=cpu"
              "OMNITTS_DTYPE=float32"
              "PYTHONUNBUFFERED=1"
            ];
            ExecStart = "${appRoot}/.venv/bin/python -m uvicorn main:app --host 0.0.0.0 --port 8000";
            Restart = "on-failure";
            RestartSec = "5s";
          };
        };

        systemd.services.omni-tts-discord-bot = {
          description = "omni-tts-discord Discord bot";
          wants = [ "network-online.target" ];
          after = [
            "network-online.target"
            "omni-tts-discord-api.service"
            "omni-tts-discord-setup.service"
          ];
          requires = [
            "omni-tts-discord-api.service"
            "omni-tts-discord-setup.service"
          ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            WorkingDirectory = "${appRoot}/packages/bot";
            Environment = [
              "HOME=${stateDir}"
              "BUN_INSTALL_CACHE_DIR=${cacheDir}/bun"
            ];
            EnvironmentFile = "/run/secrets/${appName}.env";
            ExecStart = "${bunPkg}/bin/bun --env-file=/run/secrets/${appName}.env index.ts";
            Restart = "on-failure";
            RestartSec = "5s";
          };
        };

        system.stateVersion = "25.11";
      };
  };
}
