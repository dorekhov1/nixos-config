{ config, lib, pkgs, inputs, ... }:

let
  pkgs-master = import inputs.nixpkgs-master {
    system = pkgs.system;
    config = { 
      allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
        "claude-code"
      ];
    };
  };
in
{
  environment.systemPackages = with pkgs; [
    pkgs-master.claude-code
  ];
}
