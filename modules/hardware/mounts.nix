{ pkgs, ... }:
{
  fileSystems."/mnt/kioxia" = {
    device = "/dev/disk/by-uuid/7d2f187f-18cb-4c3b-8f5f-cccb8a337afc";
    fsType = "ext4";
    options = [
      "rw"
      "nofail"
    ];
  };

  fileSystems."/mnt/windows" = {
    device = "/dev/disk/by-uuid/9660FCA060FC886F";
    fsType = "ntfs";
    options = [
      "rw"
      "uid=1000"
      "nofail"
    ];
  };

  fileSystems."/mnt/vaio" = {
    device = "/dev/disk/by-uuid/7AB6CF81B6CF3C7F";
    fsType = "ntfs-3g";
    options = [
      "rw"
      "uid=1000"
      "nofail"
    ];
  };

  # USB再接続時に自動でマウントする
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="block", ENV{ID_FS_UUID}=="7AB6CF81B6CF3C7F", TAG+="systemd", ENV{SYSTEMD_WANTS}="mnt-vaio.mount"
  '';
}
