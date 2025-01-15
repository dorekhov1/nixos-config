#
#  KDE Plasma 5 Configuration
#  Enable with "kde.enable = true;"
#  Get the plasma configs in a file with $ nix run github:pjones/plasma-manager > <file>
#

{ config, lib, pkgs, inputs, ... }:

with lib;
{
  options = {
    kde = {
      enable = mkOption {
        type = types.bool;
        default = true;
      };
    };
  };

  config = mkIf (config.kde.enable) {
    programs = {
      zsh.enable = true;
      kdeconnect = {                                # For GSConnect
        enable = true;
        package = pkgs.gnomeExtensions.gsconnect;
      };
    };

    services = {
      libinput.enable = true;
      displayManager = {
        sddm.enable = true;                       # Display Manager
      };

      xserver = {
        enable = true;

        xkb = {
          layout = "us,us,ru";
          variant = "dvp,,";
          options = "grp:win_space_toggle";
        };

        modules = [ pkgs.xf86_input_wacom ];
        wacom.enable = true;

        desktopManager.plasma5 = {
          enable = true;                            # Desktop Environment
        };
      };
      pipewire = {
        enable = true;
        alsa.enable = true;
        pulse.enable = true;
      };
    };

    environment = {
      systemPackages = with pkgs.libsForQt5; [      # System-Wide Packages
        bismuth         # Dynamic Tiling
        packagekit-qt   # Package Updater
      ];
      plasma5.excludePackages = with pkgs.libsForQt5; [
        elisa
        khelpcenter
        # konsole
        oxygen
      ];
    };

  };
}
