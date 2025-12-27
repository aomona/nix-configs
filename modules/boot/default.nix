{ ... }:
{
  #boot.loader.systemd-boot.enable = true;
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    efiInstallAsRemovable = true;
    useOSProber = true;
  };
  #boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [
    "ntfs"
    "ext4"
    "btrfs"
    "xfs"
  ];
}
