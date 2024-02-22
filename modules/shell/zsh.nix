{ config, pkgs, ... }:

{

  home-manager.users.${config.user} = {
    home.file.".config/p10k.zsh" = {
      source = ./p10k.zsh;
    };
  
    programs = {
      zsh = {
        enable = true;
        enableAutosuggestions = true;
        syntaxHighlighting.enable = true;
        enableCompletion = true;
  
        dotDir = ".config/zsh";
        oh-my-zsh = {
          enable = true;
          plugins = [ "git" ];
        };
  
        initExtra = ''
          source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
  
          POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
  
          source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
          # To customize prompt, run `p10k configure` or edit ~/.config/p10k.zsh.
          [[ ! -f ~/.config/p10k.zsh ]] || source ~/.config/p10k.zsh
  
          if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
            exec tmux
          fi
        '';
      };
    };
  };
}
