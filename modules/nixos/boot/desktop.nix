{
  pkgs,
  lib,
  hostMeta,
  ...
}:
{
  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = hostMeta.hostData.boot.lanzaboote.pkiBundle;
  };

  boot.supportedFilesystems = [
    "ntfs"
    "ext4"
    "btrfs"
    "xfs"
  ];
  environment.systemPackages = [ pkgs.sbctl ];

}
