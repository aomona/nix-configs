{ pkgs, config, ... }:
{
  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      mesa
      egl-wayland
      nvidia-vaapi-driver # VA-API追加
      libva
      libva-utils
      config.boot.kernelPackages.nvidiaPackages.stable # NVENC/CUDA用
    ];
  };

  boot.kernelModules = [ "nvidia-uvm" ];

  hardware.nvidia-container-toolkit.enable = true;

  # Wayland用カーネルパラメータ
  boot.kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];
}
