{

  description = "NixOS system configuration";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    # nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.nixpkgs.follows = "hyprland";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-master,
    nixos-hardware,
    home-manager,
    nur,
    sops-nix,
    ...
  }:
  let

    vars = {
      user = "daniil";
      fullName = "Daniil Orekhov";
      stateVersion = "23.11";
    };

    overlays = [
      nur.overlays.default
      (final: prev: { # temporary - remove when a newer version is available
        python311 = prev.python311.override {
          packageOverrides = pyFinal: pyPrev: {
            scipy = pyPrev.scipy.overridePythonAttrs (old: {
              doCheck = false;
            });
            jupyter-server = pyPrev.jupyter-server.overridePythonAttrs (old: {
              doCheck = false;
            });
          };
        };
      })
    ];

    forAllSystems = nixpkgs.lib.genAttrs [
      "x86_64-linux"
    ];

  in rec {

    nixosConfigurations = {
      a15 = import ./hosts/a15 {
       	inherit inputs nixpkgs nixpkgs-master nixos-hardware overlays vars;
      };
      vps = import ./hosts/vps {
        inherit inputs nixpkgs nixpkgs-master nixos-hardware overlays vars;
      };
    };

    homeConfigurations = {
      a15 = nixosConfigurations.a15.config.home-manager.users.${vars.user}.home;
      vps = nixosConfigurations.vps.config.home-manager.users.${vars.user}.home;
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
