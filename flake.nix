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
      url = "github:ryantm/agenix";
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
      specialArgs = {hostConf = import ./hosts/MacBook-Air-de-REMI.nix;};
      modules = [
        ./darwin.nix
        agenix.darwinModules.default
        home-manager.darwinModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.remi = {
              imports = [
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
      specialArgs = {hostConf = import ./hosts/Remis-MacBook-Pro.nix;};
      modules = [
        ./darwin.nix
        agenix.darwinModules.default
        home-manager.darwinModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.remi = {
              imports = [
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
  };
}
