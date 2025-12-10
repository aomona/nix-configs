{...}: let
  wallpaper = ../../../wallpapers/milk.png;
in {
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true; # systemdとの統合

    settings = {
      # モニター設定(240Hz対応)
      monitor = [
        "DP-1,1920x1080@240,0x0,1"
        "HDMI-A-1,1920x1080@60,1920x0,1"
      ];

      # ワークスペースをDP-1に割り当て（メインディスプレイ化）
      workspace = [
        "1, monitor:DP-1, default:true"
        "2, monitor:DP-1"
        "3, monitor:DP-1"
        "4, monitor:DP-1"
        "5, monitor:DP-1"
        "6, monitor:HDMI-A-1"
        "7, monitor:HDMI-A-1"
        "8, monitor:HDMI-A-1"
        "9, monitor:HDMI-A-1"
        "10, monitor:HDMI-A-1"
      ];

      # 環境変数
      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
      ];

      # 実行時起動
      exec-once = [
        "waybar"
        "fcitx5 -d --replace" # fcitx5を最初に起動
        "dunst"
        "swww-daemon"
        "nm-applet --indicator"
        "blueman-applet"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
        "sleep 1 && swww img ${wallpaper} --transition-type fade"
      ];

      # 入力設定
      input = {
        kb_layout = "jp";
        follow_mouse = 1;

        touchpad = {
          natural_scroll = false;
        };

        sensitivity = 0; # -1.0 - 1.0, 0はデフォルト
      };

      # 一般設定
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";

        layout = "dwindle";

        allow_tearing = false;
      };

      # 装飾
      decoration = {
        rounding = 10;

        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };

        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };
      };

      # アニメーション
      animations = {
        enabled = true;

        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      # レイアウト
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      master = {
        new_status = "master";
      };

      # その他
      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
        vrr = 2; # VRR(可変リフレッシュレート)を有効化
      };

      # キーバインド
      "$mod" = "SUPER";

      bind = [
        # アプリケーション起動
        "$mod, Return, exec, ghostty"
        "$mod, Q, killactive,"
        "$mod, M, exit,"
        "$mod, E, exec, nautilus"
        "$mod, V, togglefloating,"
        "$mod, R, exec, fuzzel"
        "$mod, P, pseudo,"
        "$mod, J, togglesplit,"
        "$mod SHIFT, F, fullscreen,"

        # vim-likeキーバインド
        "$mod, h, movefocus, l"
        "$mod, l, movefocus, r"
        "$mod, k, movefocus, u"
        "$mod, j, movefocus, d"

        # vim-likeキーバインド（ウィンドウ位置移動）
        "$mod SHIFT, h, movewindow, l"
        "$mod SHIFT, l, movewindow, r"
        "$mod SHIFT, k, movewindow, u"
        "$mod SHIFT, j, movewindow, d"

        # ワークスペース切り替え
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"

        # ウィンドウをワークスペースに移動
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"

        # スクリーンショット
        ", Print, exec, grim -g \"$(slurp)\" - | swappy -f -"
        "SHIFT, Print, exec, grim - | swappy -f -"

        # クリップボード履歴
        "$mod, C, exec, cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"

        # ロック
        "$mod, @, exec, swaylock"

        # スクロール(ワークスペース)
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"
      ];

      # マウスバインド
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      # ウィンドウルール
      windowrulev2 = [
        "float,class:^(pavucontrol)$"
        "float,class:^(blueman-manager)$"
        "float,class:^(nm-connection-editor)$"
        "opacity 0.90 0.90,class:^(ghostty)$"
        "opacity 0.95 0.95,class:^(code)$"
      ];
    };
  };
}
