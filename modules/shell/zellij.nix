{ config, ... }:
{
  home-manager.users.${config.user} = {
    programs.zellij = {
      enable = true;
      enableZshIntegration = true;
      settings = {
          theme = "catppuccin-mocha";
      };
    };
  };
}
