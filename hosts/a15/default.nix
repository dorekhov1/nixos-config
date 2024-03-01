{ inputs, vars, overlays, ... }:

with inputs;

nixpkgs.lib.nixosSystem {

  system = "x86_64-linux";
  specialArgs = { inherit inputs; };

  modules = [
    vars
    ./hardware-configuration.nix
    ../common.nix
    home-manager.nixosModules.home-manager {
        nixpkgs.overlays = overlays;
    }
    ./configuration.nix
  ];
}
