{
  description = "NixOS configuration with home-manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    # QuickShell
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    llm-agents.url = "github:numtide/llm-agents.nix";

    minecraft-nix = {
      url = "github:akazdayo/minecraft-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      nix-darwin,
      nixvim,
      lanzaboote,
      nix-flatpak,
      noctalia,
      llm-agents,
      minecraft-nix,
    }@inputs:
    let
      lib = nixpkgs.lib;
      defaultPrimaryUser = "akazdayo";

      mkPkgsUnstable =
        system:
        import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };

      mkPkgsWithLlmAgents =
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [ llm-agents.overlays.default ];
        };

      mkHost =
        hostName:
        {
          system ? "x86_64-linux",
          primaryUser ? defaultPrimaryUser,
          flakeRoot ? null,
        }:
        let
          resolvedFlakeRoot = if flakeRoot == null then "/home/${primaryUser}/configs" else flakeRoot;
          hostMeta = {
            inherit hostName system primaryUser;
            flakeRoot = resolvedFlakeRoot;
          };
          pkgs-unstable = mkPkgsUnstable system;
          pkgs-with-llm-agents = mkPkgsWithLlmAgents system;
        in
        lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit
              self
              inputs
              pkgs-unstable
              hostMeta
              ;
          };
          modules = [
            ./packages
            (./hosts + "/${hostName}")
            lanzaboote.nixosModules.lanzaboote
            home-manager.nixosModules.home-manager
            nix-flatpak.nixosModules.nix-flatpak
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${primaryUser} = import ./home;
              home-manager.extraSpecialArgs = {
                inherit
                  pkgs-unstable
                  pkgs-with-llm-agents
                  inputs
                  hostMeta
                  ;
                nixvim-module = nixvim.homeModules.nixvim;
              };
            }
          ];
        };

      mkServer =
        hostName:
        {
          system ? "x86_64-linux",
          primaryUser ? defaultPrimaryUser,
          flakeRoot ? null,
        }:
        let
          resolvedFlakeRoot = if flakeRoot == null then "/home/${primaryUser}/configs" else flakeRoot;
          hostMeta = {
            inherit hostName system primaryUser;
            flakeRoot = resolvedFlakeRoot;
          };
          pkgs-unstable = mkPkgsUnstable system;
          pkgs-with-llm-agents = mkPkgsWithLlmAgents system;
        in
        lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit
              self
              inputs
              pkgs-unstable
              hostMeta
              ;
          };
          modules = [
            ./packages
            (./hosts + "/${hostName}")
            lanzaboote.nixosModules.lanzaboote
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${primaryUser} = import ./home/server.nix;
              home-manager.extraSpecialArgs = {
                inherit
                  pkgs-unstable
                  pkgs-with-llm-agents
                  inputs
                  hostMeta
                  ;
                nixvim-module = nixvim.homeModules.nixvim;
              };
            }
          ];
        };

      mkDarwinHost =
        hostName:
        {
          system ? "aarch64-darwin",
          primaryUser ? defaultPrimaryUser,
          flakeRoot ? null,
        }:
        let
          resolvedFlakeRoot = if flakeRoot == null then "/Users/${primaryUser}/configs" else flakeRoot;
          hostMeta = {
            inherit hostName system primaryUser;
            flakeRoot = resolvedFlakeRoot;
          };
          pkgs-unstable = mkPkgsUnstable system;
          pkgs-with-llm-agents = mkPkgsWithLlmAgents system;
        in
        nix-darwin.lib.darwinSystem {
          inherit system;
          specialArgs = {
            inherit
              self
              inputs
              pkgs-unstable
              hostMeta
              ;
          };
          modules = [
            ./packages
            (./hosts + "/${hostName}")
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${primaryUser} = import ./home/darwin.nix;
              home-manager.extraSpecialArgs = {
                inherit
                  pkgs-unstable
                  pkgs-with-llm-agents
                  inputs
                  hostMeta
                  ;
                nixvim-module = nixvim.homeModules.nixvim;
              };
            }
          ];
        };

      hosts = {
        nixos = { };
      };

      servers = {
        server = { };
      };

      darwinHosts = {
        macbook = { };
      };
    in
    {
      nixosConfigurations = (lib.mapAttrs mkHost hosts) // (lib.mapAttrs mkServer servers);

      darwinConfigurations = lib.mapAttrs mkDarwinHost darwinHosts;
    };
}
