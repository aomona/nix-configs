{ pkgs, ... }:
let
  appName = "omni-tts-discord";
  nodePkg = pkgs.nodejs;
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
          "d ${cacheDir}/npm 0750 root root -"
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
            export UV_CACHE_DIR=${cacheDir}/uv
            export npm_config_cache=${cacheDir}/npm
            export npm_config_update_notifier=false
            export npm_config_fund=false
            export npm_config_audit=false
            export npm_config_ignore_scripts=true

            ${pkgs.rsync}/bin/rsync -a --delete \
              --exclude .git \
              --exclude .direnv \
              --exclude .venv \
              --exclude node_modules \
              --exclude voices \
              ${sourceRoot}/ ${appRoot}/

            cat > ${appRoot}/packages/server/main.py <<'EOF'
            import io
            import os

            import soundfile as sf
            import speaker
            import torch
            from fastapi import FastAPI, HTTPException, Response
            from omnivoice import OmniVoice
            from pydantic import BaseModel


            class GenerateParams(BaseModel):
                text: str
                speaker: str


            def resolve_dtype(dtype_name: str) -> torch.dtype:
                dtype_map = {
                    "bfloat16": torch.bfloat16,
                    "float16": torch.float16,
                    "float32": torch.float32,
                }

                if dtype_name not in dtype_map:
                    raise ValueError(f"Unsupported OMNITTS_DTYPE: {dtype_name}")

                return dtype_map[dtype_name]


            model = OmniVoice.from_pretrained(
                "k2-fsa/OmniVoice",
                device_map=os.environ.get("OMNITTS_DEVICE", "cpu"),
                dtype=resolve_dtype(os.environ.get("OMNITTS_DTYPE", "float32")),
            )

            transcript = {item.id: item.transcript for item in speaker.get_transcript()}

            app = FastAPI()


            @app.get("/")
            def read_root():
                return {"message": "Hello, World!"}


            @app.post("/generate")
            def generate_voice(params: GenerateParams):
                if not speaker.is_speaker_available(params.speaker):
                    raise HTTPException(404, "Selected speaker is not found")
                audio = model.generate(
                    text=params.text,
                    ref_audio=f"{speaker.BASE_PATH}/{params.speaker}.wav",
                    ref_text=transcript.get(params.speaker),
                    language_id=262,
                )

                buf = io.BytesIO()
                sf.write(buf, audio[0], 24000, format="WAV")
                return Response(content=buf.getvalue(), media_type="audio/wav")


            @app.get("/speaker_list", response_model=list[str])
            def get_speaker_list():
                return list(transcript)
            EOF

            find ${appRoot}/packages/bot -name '*.ts' -exec ${pkgs.perl}/bin/perl -0pi -e '
              s#from "((?:\./|\.\./)[^"]+?)\.js"#from "$1.ts"#g;
              s#from "((?:\./|\.\./)(?![^"]+\.[^"/]+")[^"]+)"#from "$1.ts"#g;
            ' {} +

            ${nodePkg}/bin/npm install --omit=dev
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
              "NODE_ENV=production"
            ];
            EnvironmentFile = "/run/secrets/${appName}.env";
            ExecStart = "${nodePkg}/bin/node --experimental-strip-types ${appRoot}/packages/bot/index.ts";
            Restart = "on-failure";
            RestartSec = "5s";
          };
        };

        system.stateVersion = "25.11";
      };
  };
}
