{ pkgs, ... }:

{
  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        output = [
          "eDP-1" # laptop screen
          "DP-1" # wide screen
        ];
        modules-left = [
          "sway/workspaces"
          "sway/mode"
        ];
        modules-center = [
          "sway/window"
          "custom/hello-from-waybar"
        ];
        modules-right = [
          "network"
          "custom/public-ip"
          "disk"
          "battery"
          "backlight"
          "clock"
          "tray"
        ];

        "disk" = {
          "unit" = "GB";
          "format" = "{used}/{total}";
        };

        "network" = {
          "format" = "{ifname}: {ipaddr}";
        };

        "backlight" = {
          "format" = "Light: {percent}%";
        };

        "battery" = {
          "format" = "Bat: {capacity}%";
          "format-charging" = "Charing: {capacity}% ({time})";
        };

        "custom/public-ip" = {
          format = "{}";
          exec = pkgs.writeShellScript "public-ip" ''
            curl -4 ifconfig.me
          '';
        };

        "sway/workspaces" = {
          disable-scroll = true;
          all-outputs = false;
        };
        "custom/hello-from-waybar" = {
          format = "hello {}";
          max-length = 40;
          interval = "once";
          exec = pkgs.writeShellScript "hello-from-waybar" ''
            echo "from within waybar"
          '';
        };
      };
    };
  };
}
