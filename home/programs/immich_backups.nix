{ pkgs, ... }:
let
  linuxVRChatFolder = "/home/akazdayo/.local/share/Steam/steamapps/compatdata/438100/pfx/drive_c/users/steamuser/Pictures/VRChat";
  windowsVRChatFolder = "/mnt/windows/Users/keenb/OneDrive/画像/VRChat";
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

    server="http://192.168.11.61:2283"
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
