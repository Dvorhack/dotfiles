{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl.url = "github:nix-community/nixGL";
  };

  outputs =
    { nixpkgs, home-manager, ... }@inputs:
    {

      # Wagner: homelab
      nixosConfigurations.Wagner = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./nixos/Wagner/configuration.nix ];
      };

      # Bruckner: vps
      nixosConfigurations.Brukner = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./nixos/Brukner/configuration.nix ];
      };

      # Strauss: Macbook
      homeConfigurations."user@Strauss" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-linux;
        extraSpecialArgs = { inherit inputs; };
        modules = [
          ./home/common.nix
          ./home/profiles/laptop.nix
          ./hosts/Strauss.nix
        ];
      };

      # Mahler: CTF Laptop
      homeConfigurations."user@Mahler" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = { inherit inputs; };
        modules = [
          ./home/common.nix
          ./home/profiles/laptop.nix
          ./hosts/Mahler.nix
        ];
      };
    };
}
