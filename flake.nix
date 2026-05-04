{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, sops-nix, ... }@inputs:
    {

      # Wagner: homelab
      nixosConfigurations.Wagner = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [ ./nixos/Wagner/configuration.nix ];
      };

      # Bruckner: vps
      nixosConfigurations.Bruckner = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/Bruckner/configuration.nix
          sops-nix.nixosModules.sops
        ];
      };

      # Strauss: Macbook
      homeConfigurations."user@Strauss" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-linux;
        extraSpecialArgs = { inherit inputs; };
        modules = [
          ./home/common.nix
          ./home/profiles/laptop.nix
          ./hosts/Strauss/home.nix
        ];
      };

      # Mahler: CTF Laptop
      homeConfigurations."user@Mahler" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = { inherit inputs; };
        modules = [
          ./home/common.nix
          ./home/profiles/laptop.nix
          ./hosts/Mahler/home.nix
        ];
      };
    };
}
