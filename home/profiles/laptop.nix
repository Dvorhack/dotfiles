{ config, pkgs, ... }:

{
  imports = [
    ../../modules/home/sway.nix
    ../../modules/home/waybar.nix
    ../../modules/home/zed.nix
    ../../modules/home/firefox.nix
  ];

  programs.zsh.initExtra = lib.mkAfter ''
    . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"

    # autostart sway
    if [ -z "$WAYLAND_DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ] ; then
        exec sway
    fi
    '';


}
