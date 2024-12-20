{ inputs, vars, overlays, ... }:

with inputs;

nixpkgs.lib.nixosSystem {

  system = "x86_64-linux";
  specialArgs = { inherit inputs; };

  modules = [
    vars
    home-manager.nixosModules.home-manager {
        nixpkgs.overlays = overlays;
        home-manager.extraSpecialArgs = { inherit inputs; };
    }

    disko.nixosModules.default
    impermanence.nixosModules.impermanence
    ./disko-config.nix

    ./hardware-configuration.nix

    ../common.nix
    ./configuration.nix
  ];

}
