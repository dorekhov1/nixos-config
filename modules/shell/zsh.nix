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
          export http_proxy=http://127.0.0.1:2334;export https_proxy=http://127.0.0.1:2334;export ALL_PROXY=socks5://127.0.0.1:2334
          if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
            exec tmux attach
          fi
        '';
      };
    };
  };
}
