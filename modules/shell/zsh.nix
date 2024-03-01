{ config, ... }:

{

  home-manager.users.${config.user} = {
  
    programs = {
      zsh = {
        enable = true;
        enableAutosuggestions = true;
        syntaxHighlighting.enable = true;
        enableCompletion = true;
  
        dotDir = ".config/zsh";
  
        initExtra = ''
          if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
            exec tmux attach
          fi
        '';
      };
    };
  };
}
