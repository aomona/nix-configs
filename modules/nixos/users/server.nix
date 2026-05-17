{ pkgs, hostMeta, ... }:
let
  primaryUser = hostMeta.primaryUser;
  hostData = hostMeta.hostData;
in
{
  users.users.${primaryUser} = {
    isNormalUser = true;
    description = primaryUser;
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "video"
      "render"
      "input"
    ];
    shell = pkgs.nushell;
    openssh.authorizedKeys.keys = hostData.users.${primaryUser}.authorizedKeys;
  };
}
