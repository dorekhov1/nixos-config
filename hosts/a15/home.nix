
{ pkgs, inputs, config, user, ... }:

{ 
  home.stateVersion = "23.11";
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
  ];
  home.persistence."/persist/home/${user}" = {
    directories = [
    ];
    files = [
    ];
    allowOther = true;
  };

  home.file = {
    "data".source = config.lib.file.mkOutOfStoreSymlink "/data";
  };

  xdg.mimeApps = {
    enable = true;

    defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
    };
  };


}
