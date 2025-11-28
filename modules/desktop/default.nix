{...}: {
  services.xserver = {
    enable = true;
    videoDrivers = ["nvidia"];

    displayManager.sessionCommands = ''
      xrandr --output DP-1 --mode 1920x1080 --rate 240
    '';
  };

  # Gnome用
  # services.displayManager.gdm.enable = true;
  # services.desktopManager.gnome.enable = true;
  # programs.dconf.enable = true;

  # KDE Plasma用
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
}
