{ config, inputs, pkgs, ... }:

{

  home-manager.users.${config.user} = {

    imports = [ 
      ./packages.nix
      ./lazyvim
    ];

    home.packages = with pkgs; [
    ];

  };
}
