{ config, lib, pkgs, vars, ... }:

{

  home.packages = with pkgs; [
    discord
    brave
    telegram-desktop
    zoom-us
  ];

  imports = [
    ./programs/astronvim
    ./programs/neovim
    ./programs/shell
  ];

}
