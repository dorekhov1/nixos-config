{ config, pkgs, ... }:

{
  home-manager.users.${config.user} = {

    imports = [ 
      ./packages.nix

      ./lazyvim
      #./astronvim
    ];

    # kickstart-nix
    # home.packages = with pkgs; [
    #     nvim-pkg
    # ];

  };
}
