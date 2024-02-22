{ config, pkgs, ... }:

{
  virtualisation = {
    docker.enable = true;
  };

  users.groups.docker.members = [ "${config.user}" ];

  environment.systemPackages = with pkgs; [
    docker                  # Containers
    docker-compose          # Multi-Container
  ];
}
