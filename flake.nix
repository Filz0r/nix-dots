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
    };

    outputs = { self, nixpkgs, nixos-23-11, nixos-06cb-009a-fingerprint-sensor,	nix-nvim, nixpkgs-unstable, ... } :
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
        in {
        nixosConfigurations = {
            ChadBook = lib.nixosSystem {
                system = "x86_64-linux";
                modules = [
                    ./configuration.nix
                    # First enable, enroll, copy blob onto the directory of the git repo
                    #nixos-06cb-009a-fingerprint-sensor.nixosModules.open-fprintd
                    #nixos-06cb-009a-fingerprint-sensor.nixosModules.python-validity
		                # Example of adding nix-nvim overlay into your configuration
                    {
                      nixpkgs.config.allowUnfree = true;
                      #unstablePkgs.config.allowUnfree = true;

                      environment.systemPackages = with pkgs; [
                        nvim-pkg
                        unstablePkgs.warp-terminal
                        unstablePkgs.zed-editor
                      ];
                    }	

                ];
                # Then enable this
                specialArgs = {
                    nixos-06cb-009a-fingerprint-sensor = nixos-06cb-009a-fingerprint-sensor;
                };
            };
        };
    };
}
