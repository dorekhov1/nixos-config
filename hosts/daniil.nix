{ config, lib, pkgs, vars, ... }:

{

  home.packages = with pkgs; [
    discord
    brave
    telegram-desktop
    zoom-us
  ];

  imports = [
    ./programs/shell
    ./programs/neovim
  ];

}
