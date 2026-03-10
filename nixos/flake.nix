{
  description = "Flake";
  inputs = {
    nixpkgs = {
      url = "github:NixOs/nixpkgs/nixos-25.05";
    };
    # Rust toolchain
    fenix.url = "github:nix-community/fenix";
    fenix.inputs.nixpkgs.follows = "nixpkgs";
    templ.url = "github:a-h/templ";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    plugin-onedark.url = "github:navarasu/onedark.nvim";
    plugin-onedark.flake = false;
  };

  outputs = {self, nixpkgs, home-manager, fenix, ...}@inputs:
    let 
      lib = nixpkgs.lib;
      system = "x86_64-linux";

    in {
    nixpkgs.overlays = [
      inputs.templ.overlays.default
    ];

    nixosConfigurations = {
      nixos = lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix

          home-manager.nixosModules.home-manager

          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.nika = {
              imports = [ ./home.nix ];
            };
          }

          ./services/postgres.nix
        ];
      };
    };
  };
}
