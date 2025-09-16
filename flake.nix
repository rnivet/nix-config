{
  description = "Home Manager configuration of ubuntu";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew = {
      url = "github:zhaofengli/nix-homebrew";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:yaxitech/ragenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    nix-darwin,
    nix-homebrew,
    home-manager,
    agenix,
    ...
  }: {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."MacBook-Air-de-REMI" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        ./darwin.nix
        home-manager.darwinModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.remi = {
              imports = [
                agenix.homeManagerModules.default
                ./home.nix
              ];
            };
            backupFileExtension = "before-nix";
            extraSpecialArgs = {hostConf = import ./hosts/MacBook-Air-de-REMI.nix;};
          };
        }
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            enableRosetta = true;
            user = "remi";
            autoMigrate = true;
          };
        }
      ];
    };

    darwinConfigurations."Remis-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        ./darwin.nix
        home-manager.darwinModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.remi = {
              imports = [
                agenix.homeManagerModules.default
                ./home.nix
              ];
            };
            backupFileExtension = "before-nix";
            extraSpecialArgs = {hostConf = import ./hosts/Remis-MacBook-Pro.nix;};
          };
        }
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            enableRosetta = true;
            user = "remi";
            autoMigrate = true;
          };
        }
      ];
    };

    homeConfigurations."rnivet@LAP-HEM-0292" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages."x86_64-linux";

      # Specify your home configuration modules here, for example,
      # the path to your home.nix.
      modules = [
        agenix.homeManagerModules.default
        ./home.nix
      ];

      # Optionally use extraSpecialArgs
      # to pass through arguments to home.nix
      extraSpecialArgs = {hostConf = import ./hosts/work.nix;};
    };
    homeConfigurations."ubuntu@ubu-1" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages."x86_64-linux";

      # Specify your home configuration modules here, for example,
      # the path to your home.nix.
      modules = [./home.nix];

      # Optionally use extraSpecialArgs
      # to pass through arguments to home.nix
      extraSpecialArgs = {hostConf = import ./hosts/ubu-1.nix;};
    };
    homeConfigurations."remi@test-home-manager" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages."aarch64-linux";

      # Specify your home configuration modules here, for example,
      # the path to your home.nix.
      modules = [./home.nix];

      # Optionally use extraSpecialArgs
      # to pass through arguments to home.nix
      extraSpecialArgs = {hostConf = import ./hosts/test-home-manager.nix;};
    };
  };
}
