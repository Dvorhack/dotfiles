{ pkgs, ... }:

{
  imports = [
    ../modules/common/shell.nix # zsh common config
    ../modules/common/neovim.nix
  ];

  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  home.packages = with pkgs; [
    btop
    gnumake
    sops
    git
    age
  ];

}
