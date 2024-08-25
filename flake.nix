{
  description = "My NixOS Configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
    nixos-23-11.url = "nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    nixos-06cb-009a-fingerprint-sensor = {
      url = "github:ahbnr/nixos-06cb-009a-fingerprint-sensor";
      inputs.nixpkgs.follows = "nixos-23-11";
    };
    nix-nvim = {
      url = "github:Filz0r/nix-nvim";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = { self, nixpkgs, nixos-23-11, nixos-06cb-009a-fingerprint-sensor, nix-nvim, nixpkgs-unstable, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          nix-nvim.overlays.default
        ];
      };
      unstablePkgs = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      nixosConfigurations = {
        ChadBook = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.filipe = import ./home.nix;
            }
            {
              nixpkgs.config.allowUnfree = true;
              environment.systemPackages = with pkgs; [
                nvim-pkg
                unstablePkgs.warp-terminal
                unstablePkgs.zed-editor
              ];
            }
          ];
        };
      };
    };
}

