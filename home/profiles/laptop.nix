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

    if [ -z "$SSH_AUTH_SOCK" ] ; then
     eval `ssh-agent -s`
     ssh-add ~/.ssh/id_rsa
    fi


    # autostart sway
    if [ -z "$WAYLAND_DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ] ; then
        export XDG_CURRENT_DESKTOP=sway
        exec sway-nvidia
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
