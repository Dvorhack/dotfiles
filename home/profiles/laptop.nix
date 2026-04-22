{ config, pkgs, ... }:

{
  imports = [
    ../modules/sway.nix
    ../modules/zed.nix
    ../modules/neovim.nix
    ../modules/firefox.nix
  ];

}
