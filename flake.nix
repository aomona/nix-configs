{
  description = "NixOS configuration with home-manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
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
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      nixvim,
      lanzaboote,
      nix-flatpak,
      noctalia,
      llm-agents,
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
      pkgs-with-llm-agents = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ llm-agents.overlays.default ];
      };
    in
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit self pkgs-unstable inputs;
        };
        modules = [
          ./configuration.nix
          ./packages
          lanzaboote.nixosModules.lanzaboote
          home-manager.nixosModules.home-manager
          nix-flatpak.nixosModules.nix-flatpak
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.akazdayo = import ./home;
            home-manager.extraSpecialArgs = {
              inherit pkgs-unstable pkgs-with-llm-agents inputs;
              nixvim-module = nixvim.homeModules.nixvim;
            };
          }
        ];
      };
    };
}
