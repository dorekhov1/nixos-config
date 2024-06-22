{ config, pkgs, ... }:
{
  home-manager.users.${config.user}.home = {
    packages = [(pkgs.ollama.override { acceleration = "cuda"; })];
  };
}
