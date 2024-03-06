{ config, inputs, pkgs, ... }:

{

  home-manager.users.${config.user} = {

    imports = [ 
      ./packages.nix

      ./lazyvim
      #./astronvim
    ];

    home.packages = with pkgs; [
    # kickstart-nix
    #     nvim-pkg

    #	neovim-nightly
    ];


  };
}
