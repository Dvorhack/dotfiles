{
  pkgs,
  lib,
  ...
}:

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

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
    config = {
      sway = {
        default = [
          "wlr"
          "gtk"
        ];
        # Specific interfaces that should use gtk
        "org.freedesktop.impl.portal.Settings" = [ "gtk" ];
        "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
      };
      common = {
        default = [ "gtk" ];
      };
    };
    xdgOpenUsePortal = true;
  };

  services.flameshot.enable = true;

}
