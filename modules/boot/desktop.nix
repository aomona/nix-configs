{ pkgs, lib, ... }:
{
  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

  boot.supportedFilesystems = [
    "ntfs"
    "ext4"
    "btrfs"
    "xfs"
  ];
  environment.systemPackages = [ pkgs.sbctl ];

}
