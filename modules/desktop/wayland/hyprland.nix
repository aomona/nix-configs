{...}: {
  # Hyprland有効化
  programs.hyprland = {
    enable = true;
    xwayland.enable = true; # X11アプリサポート(Steam、Wine等)
  };
}
