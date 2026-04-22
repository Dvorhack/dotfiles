{ config, pkgs, ... }:

{
  imports = [
    ./modules/shell.nix
  ];
  
  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };
}
