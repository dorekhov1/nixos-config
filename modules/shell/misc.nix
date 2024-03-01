{ config, lib, pkgs, ... }:

{
  home-manager.users.${config.user} = {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    programs.fzf.enable = true;
    programs.zoxide.enable = true;
    programs.btop.enable = true;
    programs.btop.settings = {
        color_theme = "horizon";
        theme_background = false;
        vim_keys = true;
    };
  
    home.packages = [
      pkgs.manix
      pkgs.xsel
      pkgs.ripgrep
      pkgs.fd
      pkgs.eza
      pkgs.bat
      pkgs.neofetch
    ];
  
    programs.zsh.shellAliases = {
      cd = "z";
      ls = "eza --icons -l -T -L=1";
      cat = "bat";
      htop = "btop";
    };
  };
}
