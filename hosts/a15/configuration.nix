{ config, lib, pkgs, inputs, overlays, ... }:

{
  imports = (
    import ../../modules/desktops ++
    import ../../modules/virtualization
  );

  boot = {
    tmp = {
      cleanOnBoot =  true;
      tmpfsSize = "5GB";
    };
    kernelPackages = pkgs.linuxPackages_latest;
    consoleLogLevel = 3;
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 2;
      };
      efi = {
	      canTouchEfiVariables = true;
      };
      timeout = 5;
    };
  };

  networking.hostName = "a15";
  networking.networkmanager.enable = true;

  #choice development
  networking.extraHosts = "127.0.0.1 api.local.choice.shopping
127.0.0.1 weaviate.local.choice.shopping
127.0.0.1 adminer.local.choice.shopping
127.0.0.1 widget.local.choice.shopping
127.0.0.1 rabbitmq.local.choice.shopping
127.0.0.1 llm.local.choice.shopping
127.0.0.1 local.lovislot.ru";


  security.pki.certificateFiles = [
    # ../../certs/choice.shopping.crt
    # /etc/ssl/certs/nginx-selfsigned.crt
  ];

  security.pki.certificates = [
  ''
-----BEGIN CERTIFICATE-----
MIIEcTCCAtmgAwIBAgIQeG9xWayyJCsT6icfYpAMMzANBgkqhkiG9w0BAQsFADBR
MR4wHAYDVQQKExVta2NlcnQgZGV2ZWxvcG1lbnQgQ0ExEzARBgNVBAsMCmRhbmlp
bEBhMTUxGjAYBgNVBAMMEW1rY2VydCBkYW5paWxAYTE1MB4XDTI0MDUyNDA4NDA0
N1oXDTM0MDUyNDA4NDA0N1owUTEeMBwGA1UEChMVbWtjZXJ0IGRldmVsb3BtZW50
IENBMRMwEQYDVQQLDApkYW5paWxAYTE1MRowGAYDVQQDDBFta2NlcnQgZGFuaWls
QGExNTCCAaIwDQYJKoZIhvcNAQEBBQADggGPADCCAYoCggGBANO2gJ7QwLiIFPKW
Z5mQlSzTnLqNRx0KtMg2ztHF3IkuPQdLG+TWtTtTw59yyOXf93HMx3zhXxWM9VDX
kKz9vEzVLJMo7aspbw6j6Wwm6/aqnZ2feg5dRnn0A605cbdow+Ok93xeIbjsZC7I
F7ESAF+feQigsH7c3Hwu/phnLb0cDmMCSLiS84sahQJ0gGm0QR0YVsuTtOIuHE9p
YNGUpTurOAgngB68buMNsrvEhTT/wAyBsSucIn1/wztHKBwYFIn9Y7ElJA4U4KU7
QUeIdSy96Ov1LHEdFk9dr48htoJZwlaZiuv9RmZ6PsdMfW5XryatwoRA70a+iqzi
o+6pfmPc6OGl6dwy/6srfY0BluU0+t9q4/cOjNuv1T2N43kWiwl5eXwiqHzj82OK
oWcf6Q8BwCSCAucV1zs+TtxhEndzAmQgNjIaAGipOhvNWaS3cuo8+OjLjA5SMxwY
MbEVQ+OAVvIQ+OfwQ5RiJ+Sf8a8fd11bfgrBoYCsFufQWlmUjwIDAQABo0UwQzAO
BgNVHQ8BAf8EBAMCAgQwEgYDVR0TAQH/BAgwBgEB/wIBADAdBgNVHQ4EFgQU55M+
GGl8Xti/RCg5hCU9CjPvLzQwDQYJKoZIhvcNAQELBQADggGBAJzNtN137XqfTP5H
toX51fL7ZK8FKmR2Cj1g2KaaSe7R2LicWJK2GjerQ9TapNoxPFvne0hwBNhs/Blb
Mf7l6uysvBkxwiojHMoogOKWjGEdDvm9wn5Kd0bFsAUgJk6TLdzJWwE1+7J/KT+b
RbrnRuvkMAjBKij3K8RyQQ7dlMkgUjPHp4IXzygBb3O/tvy3eFjXEXDrvZeOZx+E
UuSZ888IepJck3ZhOnBSYC+OPzaJv2PS3ROkuzltzTZoa4T6RsZt9EzE3JDkUUcI
0Kh19n1hge16o1Qx5u4ytpHbWjevuV/pIdNKFvPiWs653yTU9VMTrObM5BkwD9ZA
apDBp+RHveKkedHUnYgbqotsFq6qb/0Pr2dtdMBQ/5jxEGO0fLMLL/QhGrDqy6j1
PDDf+oSicBfod4ZoF+XDylE3w+2nWa7oZhGYUfMtsdx3vayG4btWNKCke28n2tFy
tprMiKGrHzYmvXhLE28X5EDFHOk8ZUTL+Oc9MnMzgylobuakZg==
-----END CERTIFICATE-----
  ''
  ];

  users.users.${config.user} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "networkmanager" ];
    shell = pkgs.zsh;
  };

  time.timeZone = "Europe/Moscow";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "ru_RU.UTF-8";
      LC_MONETARY = "ru_RU.UTF-8";
    };
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  security = {
    rtkit.enable = true;
    sudo.wheelNeedsPassword = false;
  };

  fonts.packages = with pkgs; [                # Fonts
    carlito                                 # NixOS
    vegur                                   # NixOS
    source-code-pro
    jetbrains-mono
    font-awesome                            # Icons
    corefonts                               # MS
    (nerdfonts.override {                   # Nerdfont Icons override
      fonts = [
        "NerdFontsSymbolsOnly"

        "FiraCode"
        "JetBrainsMono"
        "Iosevka"
      ];
    })
  ];


  environment = {
    systemPackages = with pkgs; [
      # Terminal
      wezterm           # Terminal Emulator
      btop              # Resource Manager
      coreutils         # GNU Utilities
      git               # Version Control
      killall           # Process Killer
      lshw              # Hardware Config
      nano              # Text Editor
      vim               # Text Editor
      nix-tree          # Browse Nix Store
      pciutils          # Manage PCI
      ranger            # File Manager
      smartmontools     # Disk Health
      tldr              # Helper
      usbutils          # Manage USB
      wget              # Retriever
      xdg-utils         # Environment integration

      # Video/Audio
      alsa-utils        # Audio Control
      feh               # Image Viewer
      # image-roll        # Image Viewer
      linux-firmware    # Proprietary Hardware Blob
      mpv               # Media Player
      pavucontrol       # Audio Control
      pipewire          # Audio Server/Control
      pulseaudio        # Audio Server/Control
      qpwgraph          # Pipewire Graph Manager
      vlc               # Media Player

      # Apps
      appimage-run      # Runs AppImages on NixOS
      brave             # Browser
      firefox           # Browser
      google-chrome     # Browser
      # remmina           # XRDP & VNC Client

      # File Management
      gnome.file-roller # Archive Manager
      pcmanfm           # File Browser
      p7zip             # Zip Encryption
      rsync             # Syncer - $ rsync -r dir1/ dir2/
      unzip             # Zip Files
      unrar             # Rar Files
      libreoffice       # Office
      zip               # Zip

      # discord
      telegram-desktop
      brave
      zoom-us
      xdg-desktop-portal
      xdg-desktop-portal-kde

      # hiddify-app

      # Screenshot tools for Wayland
      grim
      slurp
      swappy
      wl-clipboard
      wf-recorder

      # Other Packages Found @
      # - ./<host>/default.nix
      # - ../modules
      gparted
      bitwarden-desktop
      bitwarden-cli

      deluge

      wireshark
      postman
      ngrok

      obsidian

      input-remapper
      xclicker
    ];
  };

  hardware.pulseaudio.enable = false;
  services = {
    displayManager.sddm = {
	enable = true;
    };
    xserver.enable = true;
    printing = {
      enable = true;
    };
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
    };
    openssh = {
      enable = true;
      allowSFTP = true;
      extraConfig = ''
        HostKeyAlgorithms +ssh-rsa
      '';
    };
  };
  programs.ssh.startAgent = true;
  programs.mosh.enable = true;
}
