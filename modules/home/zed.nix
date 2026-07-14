{ pkgs, lib, ... }:

let
  zedSettings = pkgs.writeText "zed-settings.json" (builtins.toJSON {
    theme = "One Dark";
    ui_font_size = 16;
    buffer_font_size = 15;
    auto_install_extensions = {
      "nix" = true;
    };
  });
in
{

  # Zed needs to write to settings.json at runtime (e.g. ssh_connections
  # when you "Connect to server"), so it can't be a read-only Nix store
  # symlink. Copy it into place once instead, leaving it writable.
  home.activation.zedSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    settingsFile="$HOME/.config/zed/settings.json"
    if [ ! -e "$settingsFile" ] || [ -L "$settingsFile" ]; then
      run mkdir -p "$HOME/.config/zed"
      run install -m 0644 ${zedSettings} "$settingsFile"
    fi
  '';

  home.packages = with pkgs; [
    nil
    nixd
  ];

  # Trop de problemes, install zed using system package manager
  # home.packages = [
  #   pkgs.zed-editor
  # ];
}
