{ config, lib, pkgs, ... }:

let
  hiddify_next = with pkgs; appimageTools.wrapType2 rec {
    name = "hiddify-next";
    pname = "hiddify-next";
    version = "v2.5.7";

    src = fetchurl {
      url = "https://github.com/hiddify/hiddify-next/releases/download/${version}/Hiddify-Linux-x64.AppImage";
      hash = "sha256-5RqZ6eyurRtoOVTBLZqoC+ANi4vMODjlBWf3V4GXtMg=";
    };
    extraPkgs = pkgs: with pkgs; [ libepoxy ];
  };

  hiddify_cli = with pkgs; stdenv.mkDerivation rec {
    pname = "hiddify-cli";
    version = "3.1.8";

    src = fetchurl {
      url = "https://github.com/hiddify/hiddify-core/releases/download/v${version}/hiddify-cli-linux-amd64.tar.gz";
      hash = "sha256-en5iADDZGwxEe5XF8C9ykukAcXwDZN28fsxYURdtVDY=";
    };

    nativeBuildInputs = [
      makeWrapper
      autoPatchelfHook
    ];

    buildInputs = [
      stdenv.cc.cc.lib
      glib
      gtk3
    ];

    unpackPhase = ''
      tar xf $src
    '';

    installPhase = ''
      mkdir -p $out/{bin,lib,share}
      
      # Copy files
      if [ -f HiddifyCli ]; then
        cp HiddifyCli $out/bin/hiddify-cli
      elif [ -f webui/HiddifyCli ]; then
        cp webui/HiddifyCli $out/bin/hiddify-cli
      fi
      
      if [ -f libcore.so ]; then
        cp libcore.so $out/lib/
      elif [ -f webui/libcore.so ]; then
        cp webui/libcore.so $out/lib/
      fi
      
      # Copy webui files if they exist
      if [ -d webui ]; then
        cp -r webui $out/share/
      fi
      
      # Make the binary executable
      chmod +x $out/bin/hiddify-cli
    '';

    # Ensure the binary can find its library
    postFixup = ''
      patchelf --set-rpath "$out/lib:${lib.makeLibraryPath buildInputs}" $out/bin/hiddify-cli
      wrapProgram $out/bin/hiddify-cli \
        --set LD_LIBRARY_PATH "$out/lib:${lib.makeLibraryPath buildInputs}"
    '';

    meta = with lib; {
      description = "Hiddify CLI client";
      homepage = "https://github.com/hiddify/hiddify-core";
      license = licenses.gpl3;
      platforms = platforms.linux;
    };
  };

  hiddifyDesktopItem = pkgs.makeDesktopItem {
    name = "hiddify-next";
    desktopName = "Hiddify-Next";
    exec = "${hiddify_next}/bin/hiddify-next";
    icon = "hiddify-next";
    categories = [ "Network" ];
  };

in {
  environment.systemPackages = [
    hiddify_next
    hiddify_cli
    hiddifyDesktopItem
  ];

  # Desktop autostart entry
  environment.etc."xdg/autostart/hiddify-next.desktop".source = 
    "${hiddifyDesktopItem}/share/applications/hiddify-next.desktop";

  # Systemd service for hiddify-cli
  # systemd.services.hiddify-cli = {
  #   description = "Hiddify CLI Service";
  #   after = [ "network.target" ];
  #   wantedBy = [ "multi-user.target" ];
  #
  #   # You'll need to replace these with your actual config values
  #   environment = {
  #     HIDDIFY_CONFIG = "/path/to/your/config.json";
  #     HIDDIFY_APP_CONFIG = "/path/to/your/app-config.json";
  #   };
  #
  #   serviceConfig = {
  #     Type = "simple";
  #     ExecStart = "${hiddify_cli}/bin/hiddify-cli run -c $HIDDIFY_CONFIG -d $HIDDIFY_APP_CONFIG";
  #     Restart = "always";
  #     RestartSec = "10";
  #     User = "root"; # You might want to create a dedicated user instead
  #   };
  # };
}

