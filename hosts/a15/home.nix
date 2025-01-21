
{ pkgs, inputs, config, user, ... }:

{ 
  home.stateVersion = "23.11";
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
  ];
  home.persistence."/persist/home/${user}" = {
    directories = [
      ".ssh"
    ];
    files = [
      "~/.config/sops/age/keys.txt"
    ];
    allowOther = true;
  };

  home.file = {
    "Games".source = config.lib.file.mkOutOfStoreSymlink "/data/Games";
    "Work".source = config.lib.file.mkOutOfStoreSymlink "/data/Work";
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

  sops = {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    defaultSopsFile = ../../secrets/secrets.yaml;
    secrets.anthropic-api-key = {
      path = "%r/anthropic-api-key";
    };
  };
}
