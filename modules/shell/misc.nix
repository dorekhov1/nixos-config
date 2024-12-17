{ config, pkgs, ... }:

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
  
    home.packages = with pkgs; [
      manix
      ripgrep
      fd
      eza
      bat
      neofetch
      just

      xsel
      devenv
      openssl
      dig
      mkcert

      hollywood
    ];

    programs.zsh.shellAliases = {
      cd = "z";
      ls = "eza --icons -l -T -L=1";
      cat = "bat";
      htop = "btop";
      v = "nvim";

      startvpn = "(exec hiddify-next &> /dev/null &)";
      yc = "/home/daniil/yandex-cloud/bin/yc"; # TODO this is pretty bad

      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";
    };
  };
}
