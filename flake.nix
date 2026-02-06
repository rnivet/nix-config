{
  description = "Home Manager configuration of ubuntu";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-25.11-darwin";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-go-migrate.url = "github:nixos/nixpkgs/f62d6734af4581af614cab0f2aa16bcecfc33c11";

    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew = {
      url = "github:zhaofengli/nix-homebrew";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    nixpkgs-unstable,
    nixpkgs-go-migrate,
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
      specialArgs = {
        hostConf = import ./hosts/MacBook-Air-de-REMI.nix;
        inherit agenix;
        pkgs-go-migrate = import nixpkgs-go-migrate {
          system = "aarch64-darwin";
        };
        pkgs-unstable = import nixpkgs-unstable {
          system = "aarch64-darwin";
          config.allowUnfree = true;
        };
      };
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
            extraSpecialArgs = {
              hostConf = import ./hosts/MacBook-Air-de-REMI.nix;
              pkgs-go-migrate = import nixpkgs-go-migrate {
                system = "aarch64-darwin";
              };
              pkgs-unstable = import nixpkgs-unstable {
                system = "aarch64-darwin";
                config.allowUnfree = true;
              };
            };
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

    darwinConfigurations."Air-de-Remi" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = {
        hostConf = import ./hosts/Air-de-Remi.nix;
        inherit agenix;
        pkgs-go-migrate = import nixpkgs-go-migrate {
          system = "aarch64-darwin";
        };
        pkgs-unstable = import nixpkgs-unstable {
          system = "aarch64-darwin";
          config.allowUnfree = true;
        };
      };
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
            extraSpecialArgs = {
              hostConf = import ./hosts/Air-de-Remi.nix;
              pkgs-go-migrate = import nixpkgs-go-migrate {
                system = "aarch64-darwin";
              };
              pkgs-unstable = import nixpkgs-unstable {
                system = "aarch64-darwin";
                config.allowUnfree = true;
              };
            };
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
      specialArgs = {
        hostConf = import ./hosts/Remis-MacBook-Pro.nix;
        inherit agenix;
        pkgs-go-migrate = import nixpkgs-go-migrate {
          system = "aarch64-darwin";
        };
        pkgs-unstable = import nixpkgs-unstable {
          system = "aarch64-darwin";
          config.allowUnfree = true;
        };
      };
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
            extraSpecialArgs = {
              hostConf = import ./hosts/Remis-MacBook-Pro.nix;
              pkgs-go-migrate = import nixpkgs-go-migrate {
                system = "aarch64-darwin";
              };
              pkgs-unstable = import nixpkgs-unstable {
                system = "aarch64-darwin";
                config.allowUnfree = true;
              };
            };
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
