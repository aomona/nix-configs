{ pkgs, ... }:
{
  fileSystems."/mnt/Data" = {
    device = "/dev/disk/by-uuid/B4B4B9ACB4B9718A";
    fsType = "ntfs";
    options = [
      "rw"
      "uid=1000"
      "nofail"
    ];
  };

  fileSystems."/mnt/sdd1" = {
    device = "/dev/disk/by-uuid/7d2f187f-18cb-4c3b-8f5f-cccb8a337afc";
    fsType = "ext4";
    options = [
      "rw"
      "nofail"
    ];
  };
}
