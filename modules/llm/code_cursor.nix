{ config, pkgs, ... }: {
  environment.systemPackages = [
    pkgs.code-cursor
  ];
}
