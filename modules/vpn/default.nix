
{ pkgs, ... }:

let
  hiddify_next = import ./hiddify_next.nix {inherit pkgs;};
in {
  environment.systemPackages = [
      hiddify_next
  ];
}
