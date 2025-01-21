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

    # impermanence setup - wiping root on boot
    initrd.postDeviceCommands = lib.mkAfter ''
      mkdir /btrfs_tmp
      mount /dev/root_vg/root /btrfs_tmp
      if [[ -e /btrfs_tmp/root ]]; then
          mkdir -p /btrfs_tmp/old_roots
          timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
          mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
      fi
      
      delete_subvolume_recursively() {
          IFS=$'\n'
          for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
              delete_subvolume_recursively "/btrfs_tmp/$i"
          done
          btrfs subvolume delete "$1"
      }
      
      for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
          delete_subvolume_recursively "$i"
      done
      
      btrfs subvolume create /btrfs_tmp/root
      umount /btrfs_tmp


      mkdir /home_tmp
      mount /dev/data_vg/home /home_tmp
      if [[ -e /home_tmp/home ]]; then
      mkdir -p /home_tmp/old_homes
      timestamp=$(date --date="@$(stat -c %Y /home_tmp/home)" "+%Y-%m-%-d_%H:%M:%S")
      mv /home_tmp/home "/home_tmp/old_homes/$timestamp"
      fi

      for i in $(find /home_tmp/old_homes/ -maxdepth 1 -mtime +30); do
      delete_subvolume_recursively "$i"
      done

      btrfs subvolume create /home_tmp/home
      umount /home_tmp
    '';

  };

  networking.hostName = "a15";
  networking.networkmanager.enable = true;

  users.users.${config.user} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "networkmanager" ];
    shell = pkgs.zsh;
    hashedPasswordFile = config.sops.secrets.password.path;
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
    useXkbConfig = true;
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
    # Individual nerd-fonts packages
    nerd-fonts.symbols-only                 # NerdFontsSymbolsOnly
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.iosevka
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
      # firefox           # Browser
      google-chrome     # Browser
      # remmina           # XRDP & VNC Client

      # File Management
      file-roller       # Archive Manager
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
    pulseaudio.enable = false;
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

  # impermanence - persistence configuration
  fileSystems = {
    "/persist"= {
      neededForBoot = true;
      options = [ "noatime" ];
    };
    "/persist/home"= {
      neededForBoot = true;
      options = [ "noatime" ];
    };
    "/home"= {
      neededForBoot = true;
      options = [ "noatime" ];
    };
    "/data"= {
      neededForBoot = false;
      options = [ "noatime" ];
    };
  };

  systemd.tmpfiles.rules = [
    "d /data 0755 ${config.user} users"
    "d /home/${config.user} 0755 ${config.user} users"
    "d /persist/home/${config.user} 0755 ${config.user} users"
    "Z /home/${config.user} 0755 ${config.user} users"
    "Z /persist/home/${config.user} 0755 ${config.user} users"
    "Z /data 0755 ${config.user} users"
  ];

  systemd.services.check-mounts = {
    description = "Check if required filesystems are mounted";
    wantedBy = [ "multi-user.target" ];
    after = [ "local-fs.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "check-mounts" ''
        for dir in /persist /persist/home /home /data; do
          if ! ${pkgs.util-linux}/bin/mountpoint -q $dir; then
            echo "Error: $dir is not mounted"
            exit 1
          fi
        done
        echo "All required filesystems are mounted"
      '';
    };
  };

  environment.persistence."/persist/system" = {
    hideMounts = true;
    directories = [
      "/etc/nixos"
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
    ];
    files = [
      "/etc/machine-id"
    ];
  };

  programs.fuse.userAllowOther = true;
  home-manager = {
    extraSpecialArgs = {inherit inputs; inherit (config) user;};
    users.${config.user} = import ./home.nix;
  };

}
