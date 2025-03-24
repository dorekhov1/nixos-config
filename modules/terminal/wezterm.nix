{ config, ... }:

{
    home-manager.users.${config.user} = {
        programs.wezterm = {
            enable = true;
            extraConfig = ''
              local wezterm = require 'wezterm'
              
              -- Configure wezterm for better Neovim integration
              local config = {}
              
              -- Basic config
              config.hide_tab_bar_if_only_one_tab = true
              config.color_scheme = "Catppuccin Mocha"
              config.window_background_opacity = 0.92 -- Slightly more opaque for better readability
              
              -- Font configuration
              config.font = wezterm.font_with_fallback {
                "JetBrainsMono Nerd Font",
                "FiraCode Nerd Font",
              }
              config.font_size = 11.0
              
              -- Enable Wayland support
              config.enable_wayland = true
              
              -- Image support - use the correct enum value
              -- Note: using the enum constant from wezterm
              config.allow_square_glyphs_to_overflow_width = "WhenFollowedBySpace"
              
              -- Enable experimental graphics
              config.enable_kitty_graphics = true
              
              -- Colors for better visibility
              config.colors = {
                  cursor_bg = "#F5E0DC", -- Light pink cursor
                  cursor_fg = "#1E1E2E", -- Dark background
                  cursor_border = "#F5E0DC", -- Light border
              }
              
              -- Window padding for better content viewing
              config.window_padding = {
                  left = 4,
                  right = 4, 
                  top = 4,
                  bottom = 4,
              }
              
              -- Enhanced terminal capabilities
              config.term = "wezterm"  -- Set to xterm-256color if you encounter compatibility issues
              
              -- Use libuv backend for better performance
              config.front_end = "WebGpu"  -- Switch to "OpenGL" if performance is better
              
              -- Enable OSC 52 clipboard support (for Vim/Neovim yanking to host clipboard)
              config.enable_csi_u_key_encoding = true
              
              -- Adjust scroll behavior
              config.scrollback_lines = 10000
              
              -- Return the config
              return config
            '';
        };
    };
}
