{
  description = "Flake";
  inputs = {
    nixpkgs = {
      url = "github:NixOs/nixpkgs/nixos-24.11";
    };
    # Rust toolchain
    fenix.url = "github:nix-community/fenix";
    fenix.inputs.nixpkgs.follows = "nixpkgs";
    
    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    plugin-onedark.url = "github:navarasu/onedark.nvim";
    plugin-onedark.flake = false;
  };

  outputs = {self, nixpkgs, home-manager, nixvim, fenix, ...}@inputs:
    let 
      lib = nixpkgs.lib;
      system = "x86_64-linux";

    in {

    nixosConfigurations = {
        nixos = lib.nixosSystem {
            inherit system;
            modules = [./configuration.nix];
        };
    };
    
    homeConfigurations = {
        nika = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          extraSpecialArgs = {inherit inputs;};
          modules = [
            nixvim.homeManagerModules.nixvim
            ./home.nix
          ];
        };
    };
  };
}
