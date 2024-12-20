{ inputs, config, lib, pkgs, ... }:

{
  imports = [
    ../modules/git.nix
    ../modules/steam.nix
    ../modules/terminal/wezterm.nix
    ../modules/shell
    ../modules/llm
    ../modules/neovim
    ../modules/vpn
  ];
  
  ## Global options
  ##
  ## These can be used throughout the configuration. If a value
  ## with the same name has been declared in `globals', its
  ## value will be set as default for the respective option.
  options = let
    mkConst = const: (lib.mkOption { default = const; });
  in {

    user = lib.mkOption { # is defined in flake.nix
      type = lib.types.str;
      description = "Primary user of the system";
    };

    fullName = lib.mkOption { # is defined in flake.nix
      type = lib.types.str;
      description = "Full name of the user";
    };
    
    stateVersion = lib.mkOption { # is defined in flake.nix
      type = lib.types.str;
      description = "State version of nixos and home-manager";
    };
  };

  ## Global configuration
  ##
  ## Should only contain global settings that are not related to
  ## any particular part of the system and could therefore be
  ## extracted into their own module.
  config = {
    nix = {

      ## Enabling flakes
      extraOptions = ''
        experimental-features = nix-command flakes
        warn-dirty = false
      '';

      ## Store optimization
      optimise.automatic = true;

      ## Automatic garbage collection
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };

      settings = {
        trusted-users = ["daniil"];

        substituters = [
          "https://cache.nixos.org"
        ];
      };
    };

    ## Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    ## Global packages
    ##
    ## Packages should be managed with home-manager whereever
    ## possible. Only use a set of barebones applications here.
    environment.systemPackages = with pkgs; [ git vim wget curl ];
    environment.variables = {
      EDITOR = "nvim";
    };

    ## Home manager settings
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;

    ## Setting the `stateVersion' for both home-manager and system.
    # home-manager.users.${config.user} = {
    #   home = lib.mkMerge [
    #     {
    #       ## Setting state version for home-manager
    #       stateVersion = "${config.stateVersion}";
    #     }
    #   ];
    # };

    ## Setting state version for system
    system.stateVersion = "${config.stateVersion}";
  };
}

