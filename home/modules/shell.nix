{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    initExtra = ''
      . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"

      # autostart sway
      if [ -z "$WAYLAND_DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ] ; then
          exec sway
      fi
    '';
    shellAliases = {
      sudo = ''sudo env "PATH=$PATH"'';
    };
  };
}
