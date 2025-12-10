{ config, lib, pkgs, ... }:
{
  options.vpn.client.enable = lib.mkEnableOption "VPN client tooling (xray binary only)";

  config = lib.mkIf config.vpn.client.enable {
    environment.systemPackages = lib.mkAfter [ pkgs.xray ];
  };
}

