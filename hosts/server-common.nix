{ config, lib, pkgs, ... }:

{
  options = {
    user = lib.mkOption {
      type = lib.types.str;
      description = "Primary user of the system";
    };

    fullName = lib.mkOption {
      type = lib.types.str;
      description = "Full name of the user";
    };

    stateVersion = lib.mkOption {
      type = lib.types.str;
      description = "State version of nixos and home-manager";
    };
  };

  config = {
    nix = {
      extraOptions = ''
        experimental-features = nix-command flakes
        warn-dirty = false
      '';

      optimise.automatic = true;

      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };

      settings = {
        trusted-users = [ "root" config.user ];
        substituters = [
          "https://cache.nixos.org"
        ];
      };
    };

    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [
      git
      vim
      wget
      curl
    ];
    environment.variables = {
      EDITOR = "nvim";
    };

    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;

    system.stateVersion = config.stateVersion;
  };
}

