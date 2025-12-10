{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ../../modules/shell
    ../../modules/git.nix
    ../../modules/neovim
  ];

  # Bootloader: assume single disk /dev/vda (adjust if provider differs)
  boot.loader.grub = {
    enable = true;
    device = "/dev/vda";
  };

  networking.hostName = "vps";

  time.timeZone = "Europe/Moscow";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.${config.user} = {
    isNormalUser = true;
    description = config.fullName;
    extraGroups = [ "wheel" "docker" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKl4/L3PJwGf8P9yZ/Al0z3eWvJ7dRH0ltgfC2XwIS1K daniil@vps"
    ];
  };

  security.sudo.wheelNeedsPassword = false;

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  environment.systemPackages = with pkgs; [
    btop
    tmux
    ripgrep
    fd
    eza
    traceroute
    mtr
    nmap
    netcat-openbsd
    iperf3
    dnsutils
    xray-core
    docker-compose
  ];

  services.fail2ban.enable = true;

  networking.firewall = {
    allowedTCPPorts = [ 22 80 443 ];
    allowedUDPPorts = [ 443 ];
  };

  virtualisation = {
    docker.enable = true;
    oci-containers = {
      backend = "docker";
      containers.xui = {
        image = "enwaiax/x-ui:latest";
        autoStart = true;
        ports = [
          "127.0.0.1:54321:54321" # admin panel (bind to localhost; tunnel via SSH)
          "0.0.0.0:80:80"
          "0.0.0.0:443:443"
        ];
        volumes = [
          "/var/lib/x-ui:/etc/x-ui"
        ];
        environment = {
          TZ = config.time.timeZone;
        };
      };
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/x-ui 0750 root root -"
  ];

  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
      inherit (config) user;
    };
    users.${config.user}.home.stateVersion = config.stateVersion;
  };

  # Ensure system zsh bits are available since the user shell is zsh
  programs.zsh.enable = true;
}

