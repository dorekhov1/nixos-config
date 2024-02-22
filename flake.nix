{

  description = "NixOS system configuration";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-flake = {
      url = "github:dorekhov1/kickstart-nix.nvim";
    };

  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixos-hardware,
    home-manager,
    nixvim,
    ...
  }:
  let

    vars = rec {
      user = "daniil";
      fullName = "Daniil Orekhov";
      stateVersion = "23.11";
    };

    overlays = [
      inputs.neovim-flake.overlays.default
    ];

  in rec {

    nixosConfigurations = {
      a15 = import ./hosts/a15 {
       	inherit inputs nixpkgs nixos-hardware overlays vars;
      };
    };

    homeConfigurations = {
      a15 = nixosConfigurations.a15.config.home-manager.users.${vars.user}.home;
    };

  };
}
