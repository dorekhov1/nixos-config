{ config, ... }:

{

  home-manager.users.${config.user} = {

    imports = [ 
      ./packages.nix
      ./lazyvim
    ];

  };
}
