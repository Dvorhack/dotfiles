# home/server-common.nix
{ nixosConfig, ... }:
{
  imports = [ ./common.nix ]; # your shared zsh, btop, etc.

  programs.ssh = {
    enable = true;
    matchBlocks."my-server" = {
      identityFile = nixosConfig.sops.secrets."api-key".path;
    };
  };

  home.stateVersion = "25.05";
}
