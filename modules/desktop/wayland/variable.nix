{ ... }:
{
  # Wayland環境変数(NVIDIA最適化)
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1"; # NVIDIAカーソル問題回避
    NIXOS_OZONE_WL = "1"; # Electron (Vesktop等)
    MOZ_ENABLE_WAYLAND = "1"; # Firefox
    TZ = "Asia/Tokyo";

    # fcitx5 IME設定
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    GLFW_IM_MODULE = "ibus"; # ゲーム用
  };
}
