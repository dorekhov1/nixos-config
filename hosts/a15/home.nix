
{ pkgs, inputs, config, ... }:

{ 
  home.stateVersion = "23.11";
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
  ];
  home.persistence."/persist/home" = {
    directories = [
      "Projects"
    ];
    files = [
    ];
    allowOther = true;
  };
}
