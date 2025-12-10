{...}: {
  programs.waybar = {
    enable = true;
    systemd.enable = false;
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
}
