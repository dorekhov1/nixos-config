{ config, ... }:

{
    home-manager.users.${config.user} = {
        programs.wezterm.enable = true;
        programs.wezterm.extraConfig = ''
          local wezterm = require 'wezterm'

          return {
              hide_tab_bar_if_only_one_tab = true,
              color_scheme = "Catppuccin Mocha",
              window_background_opacity = 0.8,
              font = wezterm.font_with_fallback {
                "JetBrainsMono Nerd Font",
                "FiraCode Nerd Font",
              }
          }
        '';
    };
}
