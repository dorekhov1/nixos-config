
{ config, pkgs, ... }:
{
  home-manager.users.${config.user} = {
    programs = {
      tmux = {
        enable = true;
        shortcut = "Space";
        keyMode = "vi";
        mouse = true;
        newSession = true;
        terminal = "screen-256color";
        clock24 = true;
        sensibleOnTop = true;
        plugins = with pkgs; [
          tmuxPlugins.vim-tmux-navigator
          tmuxPlugins.resurrect
          tmuxPlugins.yank
          tmuxPlugins.tmux-thumbs
          tmuxPlugins.tmux-fzf
          tmuxPlugins.prefix-highlight
          tmuxPlugins.better-mouse-mode
          tmuxPlugins.net-speed
          {
            plugin = tmuxPlugins.catppuccin;
            extraConfig = ''
              set -g @catppuccin_flavour 'mocha'
            '';
          }
        ];
        extraConfig = ''
          bind l list-sessions

          bind s split-window -v -c "#{pane_current_path}"
          bind v split-window -h -c "#{pane_current_path}"

          bind -n M-H previous-window
          bind -n M-L next-window

          bind-key -T copy-mode-vi v send-keys -X begin-selection
          bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
          bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
        '';
      };
    };
  };

}
