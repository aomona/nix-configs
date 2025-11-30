{
  pkgs,
  pkgs-stable,
  pkgs-xr,
  ...
}: {
  home.packages =
    (with pkgs; [
      vesktop
      zed-editor
      osu-lazer-bin
      lmstudio
      wlx-overlay-s
      obsidian
      zoom-us
      spotify
      google-chrome
      vrcx
      _1password-gui
      tor-browser
      gh
      unityhub
      claude-code
      bs-manager
      alcom
      wineWowPackages.stable # 64bit + 32bit対応
      winetricks
      lutris
    ])
    ++ (with pkgs-stable; [
      # stable 25.05
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
    ])
    ++ (with pkgs-xr; [
      # nixpkgs-xr
    ]);
}
