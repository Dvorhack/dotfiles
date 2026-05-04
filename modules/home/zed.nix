{ pkgs, ... }:

{

  home.file.".config/zed/settings.json".text = builtins.toJSON {
    theme = "One Dark";
    ui_font_size = 16;
    buffer_font_size = 15;
    auto_install_extensions = {
      "nix" = true;
    };
  };

  home.packages = with pkgs; [
    nil
    nixd
  ];

  # Trop de problemes, install zed using system package manager
  # home.packages = [
  #   pkgs.zed-editor
  # ];
}
