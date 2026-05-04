{
  config,
  pkgs,
  lib,
  ...
}:

{
  home.packages = with pkgs; [
    swaynotificationcenter
  ];

  systemd.user.sessionVariables = {
    PATH = "$HOME/.nix-profile/bin:$PATH";
    XDG_DATA_DIRS = lib.mkForce (
      "$HOME/.nix-profile/share"
      + ":"
      + "/etc/profiles/per-user/$USER/share"
      + ":"
      + builtins.getEnv "XDG_DATA_DIRS"
    );
  };

  wayland.windowManager.sway = {
    enable = true;
    package = null;
    config = {
      modifier = "Mod4"; # Windows key
      terminal = "alacritty";
      menu = "exec wofi --show drun";

      bars = [
        {
          "command" = "waybar";
        }
      ];

      keybindings =
        let
          mod = config.wayland.windowManager.sway.config.modifier;
        in
        {
          "${mod}+Return" = "exec alacritty";
          "${mod}+Space" = "exec wofi --show drun";
          "${mod}+q" = "kill";
          "${mod}+Shift+r" = "reload";
          "${mod}+Shift+e" = "exit";
          "${mod}+Shift+o" = "exec swaylock";

          "${mod}+Left" = "focus left";
          "${mod}+Down" = "focus down";
          "${mod}+Up" = "focus up";
          "${mod}+Right" = "focus right";

          "${mod}+Shift+Left" = "move left";
          "${mod}+Shift+down" = "move down";
          "${mod}+Shift+Up" = "move up";
          "${mod}+Shift+Right" = "move right";

          "${mod}+1" = "workspace number 1";
          "${mod}+2" = "workspace number 2";
          "${mod}+3" = "workspace number 3";
          "${mod}+4" = "workspace number 4";
          "${mod}+5" = "workspace number 5";
          "${mod}+6" = "workspace number 6";
          "${mod}+7" = "workspace number 7";
          "${mod}+8" = "workspace number 8";
          "${mod}+9" = "workspace number 9";
          "${mod}+0" = "workspace number 10";

          "${mod}+Shift+1" = "move container to workspace number 1";
          "${mod}+Shift+2" = "move container to workspace number 2";
          "${mod}+Shift+3" = "move container to workspace number 3";
          "${mod}+Shift+4" = "move container to workspace number 4";
          "${mod}+Shift+5" = "move container to workspace number 5";
          "${mod}+Shift+6" = "move container to workspace number 6";
          "${mod}+Shift+7" = "move container to workspace number 7";
          "${mod}+Shift+8" = "move container to workspace number 8";
          "${mod}+Shift+9" = "move container to workspace number 9";
          "${mod}+Shift+0" = "move container to workspace number 10";

          # Layout
          "${mod}+w" = "layout tabbed";
          "${mod}+s" = "layout stacking";
          "${mod}+f" = "fullscreen";

          # scratchpad
          "${mod}+BackSpace" = "scratchpad show";
          "${mod}+Shift+BackSpace" = "move scratchpad";

          # test
          "${mod}+Shift+m" = "exec /tmp/toto.sh > /tmp/sway_exec.log";

          #"${mod}+" = "";
        };
      startup = [
        { command = "swaync"; }
      ];
    };

    extraConfig = ''
      set $term alacritty
      set $ddterm-id dropdown-terminal
      set $ddterm $term --class $ddterm-id
      set $ddterm-resize resize set 40ppt 40ppt, move position center
      for_window [app_id="$ddterm-id"] {
        floating enable
        $ddterm-resize
        move to scratchpad
        scratchpad show
      }
      bindsym Mod4+u exec swaymsg '[app_id="$ddterm-id"] scratchpad show' || $ddterm  && sleep .1 && swaymsg '[app_id="$ddterm-id"] $ddterm-resize'


      set $ddterm2-id dropdown-python
      set $ddterm2 $term --class $ddterm2-id -e 'python3'
      set $ddterm2-resize resize set 40ppt 40ppt, move position center
      for_window [app_id="$ddterm2-id"] {
        floating enable
        $ddterm2-resize
        move to scratchpad
        scratchpad show
      }
      bindsym Mod4+y exec swaymsg '[app_id="$ddterm2-id"] scratchpad show' || $ddterm2  && sleep .1 && swaymsg '[app_id="$ddterm2-id"] $ddterm-resize'

    '';
  };
}
