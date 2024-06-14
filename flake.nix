{

  description = "NixOS system configuration";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    tmux-sessionx = {
        url = "github:omerxx/tmux-sessionx";
    };

    # nix-secrets = {
    #   url = "git+ssh://git@gitlab.com/emergentmind/nix-secrets.git?ref=main&shallow=1";
    #   flake = false;
    # };

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
      # inputs.neovim-flake.overlays."x86_64-linux".default
    ];

    forAllSystems = nixpkgs.lib.genAttrs [
      "x86_64-linux"
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

    templates = {
      python = {
        path = ./templates/python;
        description = "Custom Python development environment";
      };
    };

    devShells = forAllSystems
      (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in import ./shell.nix { inherit pkgs; }
      );
  };
}
