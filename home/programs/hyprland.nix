{...}: {
  imports = [
    ./wayland/hyprland.nix # WindowManager
    ./wayland/waybar.nix # StatusBar
    ./wayland/dunst.nix # NotifyDaemon
  ];
}
