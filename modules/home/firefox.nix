{ pkgs, ... }:

{
  programs.firefox = {
    enable = true;
  };

  # Run Firefox natively on Wayland instead of XWayland, otherwise
  # getDisplayMedia can't use the xdg-desktop-portal-wlr/PipeWire picker
  # (screen sharing in Discord etc. fails silently or shows a blank frame).
  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
  };
}
