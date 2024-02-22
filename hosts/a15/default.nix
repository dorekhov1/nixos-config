{ inputs, vars, overlays, ... }:

with inputs;

nixpkgs.lib.nixosSystem {

  system = "x86_64-linux";

  modules = [
    vars
    ./hardware-configuration.nix
    ../common.nix
    nixvim.nixosModules.nixvim
    home-manager.nixosModules.home-manager {
        nixpkgs.overlays = overlays;
    }
    ./configuration.nix
  ];
}
