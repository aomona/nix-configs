{ hostMeta, ... }:
let
  fileSystemData = hostMeta.hostData.fileSystems;
in
{
  fileSystems.${fileSystemData.kioxia.mountPoint} = {
    device = fileSystemData.kioxia.device;
    fsType = "ext4";
    options = [
      "rw"
      "nofail"
    ];
  };

  fileSystems.${fileSystemData.windows.mountPoint} = {
    device = fileSystemData.windows.device;
    fsType = "ntfs";
    options = [
      "rw"
      "uid=1000"
      "nofail"
    ];
  };

  fileSystems.${fileSystemData.vaio.mountPoint} = {
    device = fileSystemData.vaio.device;
    fsType = "ntfs-3g";
    options = [
      "rw"
      "uid=1000"
      "nofail"
    ];
  };

  # USB再接続時に自動でマウントする
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="block", ENV{ID_FS_UUID}=="${fileSystemData.vaio.uuid}", TAG+="systemd", ENV{SYSTEMD_WANTS}="mnt-vaio.mount"
  '';
}
