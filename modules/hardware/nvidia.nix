{pkgs, config, ...}: {
  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      mesa
      egl-wayland
      nvidia-vaapi-driver # VA-API追加
      libva
      libva-utils
    ];
  };

  boot.kernelModules = ["nvidia-uvm"];

  # Wayland用カーネルパラメータ
  boot.kernelParams = ["nvidia.NVreg_PreserveVideoMemoryAllocations=1"];
}
