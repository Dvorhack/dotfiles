{ config, pkgs, ... }:

{
  imports = [
    ../modules/sway.nix
    ../modules/waybar.nix
    ../modules/zed.nix
    ../modules/neovim.nix
    ../modules/firefox.nix
  ];

}
