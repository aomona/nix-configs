{
  pkgs,
  pkgs-unstable,
  pkgs-with-llm-agents,
  ...
}:
{
  home.packages =
    (with pkgs; [
      comma
      creator-companion-tui
      vpm-cli
      vrcli
      devenv
      vim
      nixd
      nil
      alejandra
      nixfmt
      starship
      fastfetch
      tree
      xdg-utils
      wl-clipboard
      xwayland-satellite
      slack
      ghostty
      libreoffice
      signal-desktop
      termius
      jq
      wget
      lmstudio
      wlx-overlay-s
      tor-browser
      alcom
      google-chrome
      osu-lazer-bin
      nautilus
      code-cursor
      unar
      kooha
      yt-dlp
      ffmpeg
      btop-cuda
      tailscale
      lazygit
      nostui

      # Wayland共通ツール
      brightnessctl # 輝度調整
      playerctl # メディアコントロール
      pavucontrol # 音量設定GUI
      networkmanagerapplet # ネットワーク管理
      blueman # Bluetooth管理
      nwg-look # GTKテーマ設定
      libsForQt5.qt5ct # Qtテーマ設定
      kdePackages.qt6ct
      polkit_gnome # 認証エージェント
      vlc
      wineWowPackages.stable # 64bit + 32bit対応
      winetricks
      vesktop
      obsidian
      vrcx
      gh
      unityhub
      nvtopPackages.nvidia
      protonup-qt
      kdePackages.dolphin
      immich-go
      zoom-us

    ])
    ++ (with pkgs-with-llm-agents.llm-agents; [
      # LLM Agents from numtide/llm-agents.nix
      opencode
    ])
    ++ (with pkgs.cudaPackages_12_8; [
      # CUDA 12.8 (機械学習用)
      cudatoolkit
    ])
    ++ (with pkgs-unstable; [
      # unstable 26.05
      wayvr
      protonvpn-gui
      wireguard-tools
      codex
      bs-manager
    ]);
}
