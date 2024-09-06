{
    description = "My flake, wtf";

    inputs = {
        nixpkgs.url = "nixpkgs/nixos-24.05";
        nixos-23-11.url = "nixpkgs/nixos-23.11";
	      nixpkgs-unstable.url = "nixpkgs/nixos-unstable"; # Add unstable nixpkgs
        nixos-06cb-009a-fingerprint-sensor = {
            url = "github:ahbnr/nixos-06cb-009a-fingerprint-sensor";
            inputs.nixpkgs.follows = "nixos-23-11";
        };
	      nix-nvim = {
		        url = "github:Filz0r/nix-nvim";
		        inputs.nixpkgs.follows = "nixpkgs-unstable";
	      };
        home-manager = {
            url = "github:nix-community/home-manager/release-24.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { self, nixpkgs, nixos-23-11, nixos-06cb-009a-fingerprint-sensor,	nix-nvim, nixpkgs-unstable, home-manager, ... } :
        let
            lib = nixpkgs.lib;
	          system = "x86_64-linux";  # Define the system architecture
            config.allowUnfree = true;
    	      pkgs = import nixpkgs {
      		    inherit system;
              config.allowUnfree = true;
      		    overlays = [
        		    nix-nvim.overlays.default  # Use the overlay provided by the nix-nvim input
       	      ];
    	  	  };

            # Import unstable nixpkgs
            unstablePkgs = import nixpkgs-unstable {
              inherit system;
              config.allowUnfree = true;
            };
            homepkgs = nixpkgs.legacyPackages.${system};
#            homePkgs = import home-manager {
#                inherit system;
#                modules = [ home-manager.nixosModules.home-manager ];
#            };
        in {
        nixosConfigurations = {
            ChadBook = lib.nixosSystem {
                system = "x86_64-linux";
                modules = [
                    ./configuration.nix
                    # First enable, enroll, copy blob onto the directory of the git repo
                    #nixos-06cb-009a-fingerprint-sensor.nixosModules.open-fprintd
                    #nixos-06cb-009a-fingerprint-sensor.nixosModules.python-validity

 		                # Enabling my nvim-pkg flake and adding unstable packages
                    {
                      nixpkgs.config.allowUnfree = true;
                      #unstablePkgs.config.allowUnfree = true;

                      environment.systemPackages = with pkgs; [
                        nvim-pkg
#                        home-manager
                        unstablePkgs.warp-terminal
                        unstablePkgs.zed-editor
                        unstablePkgs.jetbrains.clion
                      ];
                    }

                ];
                # Then enable this
                specialArgs = {
                    nixos-06cb-009a-fingerprint-sensor = nixos-06cb-009a-fingerprint-sensor;
                };
            };
        };
        homeConfigurations = {
          filipe = home-manager.lib.homeManagerConfiguration {
            inherit homepkgs; 
            modules = [
              ./home.nix 
              {
                  home-manager.useGlobalPkgs = true;
                  home-manager.useUserPackages = true;
                  home-manager.users.filipe = import ./home.nix;
              }
            ];
          };
        };
    };
}
