{
  config,
  pkgs,
  lib,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true; # systemdとの統合

    settings = {
      # モニター設定(240Hz対応)
      monitor = [
        "DP-1,1920x1080@240,0x0,1"
        ",preferred,auto,1" # その他のモニター
      ];

      # 環境変数
      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
      ];

      # 実行時起動
      exec-once = [
        "waybar"
        "dunst"
        "swww-daemon"
        "nm-applet --indicator"
        "blueman-applet"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
      ];

      # 入力設定
      input = {
        kb_layout = "us";
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

        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
        "col.shadow" = "rgba(1a1a1aee)";
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

        # フォーカス移動
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        # vim-likeキーバインド
        "$mod, h, movefocus, l"
        "$mod, l, movefocus, r"
        "$mod, k, movefocus, u"
        "$mod, j, movefocus, d"

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
        "$mod, L, exec, swaylock"

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
      windowrule = [
        "float, ^(pavucontrol)$"
        "float, ^(blueman-manager)$"
        "float, ^(nm-connection-editor)$"
      ];

      windowrulev2 = [
        "opacity 0.90 0.90,class:^(ghostty)$"
        "opacity 0.95 0.95,class:^(code)$"
      ];
    };
  };

  # Waybar設定
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;

        modules-left = ["hyprland/workspaces" "hyprland/window"];
        modules-center = ["clock"];
        modules-right = ["pulseaudio" "network" "cpu" "memory" "temperature" "tray"];

        "hyprland/workspaces" = {
          format = "{icon}";
          on-click = "activate";
          format-icons = {
            "1" = "1";
            "2" = "2";
            "3" = "3";
            "4" = "4";
            "5" = "5";
            "6" = "6";
            "7" = "7";
            "8" = "8";
            "9" = "9";
            "10" = "10";
          };
        };

        clock = {
          format = "{:%Y-%m-%d %H:%M}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        cpu = {
          format = "CPU {usage}%";
        };

        memory = {
          format = "MEM {}%";
        };

        network = {
          format-wifi = " {essid}";
          format-ethernet = " {ipaddr}";
          format-disconnected = "⚠ Disconnected";
          tooltip-format = "{ifname}: {ipaddr}";
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = " Muted";
          format-icons = {
            default = ["" "" ""];
          };
          on-click = "pavucontrol";
        };

        temperature = {
          critical-threshold = 80;
          format = " {temperatureC}°C";
        };

        tray = {
          spacing = 10;
        };
      };
    };

    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 13px;
      }

      window#waybar {
        background-color: rgba(43, 48, 59, 0.9);
        border-bottom: 3px solid rgba(100, 114, 125, 0.5);
        color: #ffffff;
      }

      #workspaces button {
        padding: 0 5px;
        background-color: transparent;
        color: #ffffff;
      }

      #workspaces button:hover {
        background: rgba(0, 0, 0, 0.2);
      }

      #workspaces button.active {
        background-color: #64727D;
      }

      #clock,
      #cpu,
      #memory,
      #network,
      #pulseaudio,
      #temperature,
      #tray {
        padding: 0 10px;
        margin: 0 5px;
      }
    '';
  };

  # Dunst通知デーモン
  services.dunst = {
    enable = true;
    settings = {
      global = {
        width = 300;
        height = 300;
        offset = "30x50";
        origin = "top-right";
        transparency = 10;
        frame_color = "#89b4fa";
        font = "JetBrainsMono Nerd Font 10";
      };

      urgency_low = {
        background = "#1e1e2e";
        foreground = "#cdd6f4";
        timeout = 5;
      };

      urgency_normal = {
        background = "#1e1e2e";
        foreground = "#cdd6f4";
        timeout = 10;
      };

      urgency_critical = {
        background = "#1e1e2e";
        foreground = "#cdd6f4";
        frame_color = "#f38ba8";
        timeout = 0;
      };
    };
  };

  # Swaylock設定
  # swaylock-effectsを使用（packages.nixで追加済み）
  # 設定ファイルはfiles.nixでdotfilesから読み込み
}
