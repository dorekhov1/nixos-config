{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ../../modules/shell
    ../../modules/git.nix
    ../../modules/vpn
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
    extraGroups = [ "wheel" ];
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
  ];

  services.fail2ban.enable = true;

  networking.firewall = {
    allowedTCPPorts = [ 22 ];
    allowedUDPPorts = [ ];
  };

  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
      inherit (config) user;
    };
    users.${config.user} = {
      home.stateVersion = config.stateVersion;
      programs.zellij.enable = lib.mkForce false;
    };
  };

  # Ensure system zsh bits are available since the user shell is zsh
  programs.zsh.enable = true;

  vpn = {
    server = {
      enable = true;
      domain = "dorekhov.xyz";
      secretsFile = ../../secrets/secrets.decrypted.yaml;
    };
    client.enable = false;
  };
}

