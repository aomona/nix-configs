{ pkgs, hostMeta, ... }:
let
  immichBackupData = hostMeta.hostData.immichBackups;
  linuxVRChatFolder = immichBackupData.linuxVRChatFolder;
  windowsVRChatFolder = immichBackupData.windowsVRChatFolder;
  immichBackups = pkgs.linkFarm "immichBackups" [
    {
      name = "linuxVRChatFolder";
      path = linuxVRChatFolder;
    }
    {
      name = "windowsVRChatFolder";
      path = windowsVRChatFolder;
    }
  ];
  immichBackup = pkgs.writeShellScriptBin "immich-backup" ''
    set -euo pipefail

    server="${immichBackupData.server}"
    api_key="$(cat /run/secrets/immich-api-key)"

    for entry in "${immichBackups}"/*; do
      if [ ! -e "$entry" ]; then
        continue
      fi

      target="$(readlink -f "$entry")"

      "${pkgs.immich-go}/bin/immich-go" upload from-folder \
        --server="$server" \
        --api-key="$api_key" \
        "$target"
    done
  '';
in
{
  home.packages = [
    immichBackups
    immichBackup
  ];
}
