{
  pkgs,
  pkgs-unstable,
  ...
}: {
  home.packages =
    (with pkgs; [
      vim
      nixd
      nil
      alejandra
      starship
      fastfetch
      tree
      xdg-utils
      wl-clipboard
      slack
      ghostty
      direnv
      libreoffice
      signal-desktop
      termius
      bat
      jq
      wget
      lmstudio
      wlx-overlay-s
      tor-browser
      alcom
      _1password-gui
      google-chrome
    ])
    ++ (with pkgs-unstable; [
      # unstable 26.05
      vesktop
      zed-editor
      osu-lazer-bin
      obsidian
      zoom-us
      spotify
      vrcx
      gh
      unityhub
      claude-code
      bs-manager
      wineWowPackages.stable # 64bit + 32bit対応
      winetricks
      lutris
    ]);
}
