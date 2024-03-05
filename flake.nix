{

  description = "NixOS system configuration";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    astronvim = {
        url = "github:AstroNvim/AstroNvim/v3.41.2";
        flake = false;
    };

    neovim-flake = {
      url = "github:dorekhov1/kickstart-nix.nvim";
    };

    tmux-sessionx = {
        url = "github:omerxx/tmux-sessionx";
    };

  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixos-hardware,
    home-manager,
    ...
  }:
  let

    vars = {
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
