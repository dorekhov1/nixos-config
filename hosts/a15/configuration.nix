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
      image-roll        # Image Viewer
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
      remmina           # XRDP & VNC Client

      # File Management
      gnome.file-roller # Archive Manager
      pcmanfm           # File Browser
      p7zip             # Zip Encryption
      rsync             # Syncer - $ rsync -r dir1/ dir2/
      unzip             # Zip Files
      unrar             # Rar Files
      libreoffice       # Office
      zip               # Zip

      discord
      telegram-desktop
      brave
      zoom-us
      # Other Packages Found @
      # - ./<host>/default.nix
      # - ../modules
    ];
  };

  hardware.pulseaudio.enable = false;
  services = {
    xserver.enable = true;
    xserver.displayManager.sddm.enable = true;
    xserver.desktopManager.plasma5.enable = true;
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
}
