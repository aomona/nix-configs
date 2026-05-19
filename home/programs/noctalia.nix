{ ... }:
{
  # Noctalia Shell設定
  # systemd.enable is deprecated — noctalia-shell is spawned directly by niri via spawn-at-startup.
  programs.noctalia-shell = {
    enable = true;
  };
}
