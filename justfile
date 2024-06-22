rebuild:
  nixos-rebuild switch --flake . --use-remote-sudo --option eval-cache false --show-trace

update:
  nix flake update
