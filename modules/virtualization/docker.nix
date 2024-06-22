{ config, pkgs, ... }:

{
  virtualisation.docker = {
    enable = true;
    enableNvidia = true;
  };

  users.groups.docker.members = [ "${config.user}" ];

  environment.systemPackages = with pkgs; [
    docker
    docker-compose
    kubectl
    kubernetes-helm
  ];
}
