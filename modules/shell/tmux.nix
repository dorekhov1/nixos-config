
{ config, pkgs, inputs, ... }:
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
        escapeTime = 300;
        historyLimit = 1000000;
        plugins = with pkgs.tmuxPlugins; [
          vim-tmux-navigator
          yank
          tmux-thumbs
          tmux-fzf
          {
              plugin = fzf-tmux-url;
              extraConfig = ''
                set -g @fzf-url-fzf-options '-p 60%,30% --prompt="   " --border-label=" Open URL "'
                set -g @fzf-url-history-limit '2000'
              '';
          }
          extrakto
          better-mouse-mode
          {
            plugin = catppuccin;
            extraConfig = ''
              set -g @catppuccin_flavour 'mocha'
              set -g @catppuccin_window_left_separator ""
              set -g @catppuccin_window_right_separator " "
              set -g @catppuccin_window_middle_separator " █"
              set -g @catppuccin_window_number_position "right"
              set -g @catppuccin_window_default_fill "number"
              set -g @catppuccin_window_default_text "#W"
              set -g @catppuccin_window_current_fill "number"
              set -g @catppuccin_window_current_text "#W#{?window_zoomed_flag,(),}"
              set -g @catppuccin_status_modules_right "directory meetings date_time"
              set -g @catppuccin_status_modules_left "session"
              set -g @catppuccin_status_left_separator  " "
              set -g @catppuccin_status_right_separator " "
              set -g @catppuccin_status_right_separator_inverse "no"
              set -g @catppuccin_status_fill "icon"
              set -g @catppuccin_status_connect_separator "no"
              set -g @catppuccin_directory_text "#{b:pane_current_path}"
              set -g @catppuccin_meetings_text "#($HOME/.config/tmux/scripts/cal.sh)"
              set -g @catppuccin_date_time_text "%H:%M"
            '';
          }
          {
            plugin = inputs.tmux-sessionx.packages."${pkgs.system}".default;
            extraConfig = ''
              set -g @sessionx-x-path '~/.dotfiles'
              set -g @sessionx-bind 'o'
              set -g @sessionx-zoxide-mode 'on'
              set -g @sessionx-preview-enabled 'true'
            '';
          }
          {
            plugin = resurrect;
            extraConfig = ''
              set -g @resurrect-strategy-nvim 'session'
              set -g @resurrect-dir '~/.tmux/ressurect'
            '';
          }
          {
            plugin = continuum;
            extraConfig = ''
              set -g @continuum-save-interval '5'
              set -g @continuum-restore 'on'
            '';
          }
        ];
        extraConfig = ''

          bind l list-sessions

          bind s split-window -v -c "#{pane_current_path}"
          bind v split-window -h -c "#{pane_current_path}"

          bind -n M-H previous-window
          bind -n M-L next-window

          bind -r H resize-pane -L 5
          bind -r J resize-pane -D 5
          bind -r K resize-pane -U 5
          bind -r L resize-pane -R 5

          bind-key -n C-S-Left swap-window -d -t -1
          bind-key -n C-S-Right swap-window -d -t +1
          bind-key -n MouseDrag1Status swap-window -d -t=

          bind Escape copy-mode
          bind-key -T copy-mode-vi v send-keys -X begin-selection
          bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
          bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
          unbind -Tcopy-mode-vi Enter

          set -g renumber-windows on

          set -g status-position top
        '';
      };
    };
  };

}
