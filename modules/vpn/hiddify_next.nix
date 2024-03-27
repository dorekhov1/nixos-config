{ pkgs }:

with pkgs;
appimageTools.wrapType2 rec {
  name = "hiddify-next";
  pname = "hiddify-next";
  version = "v0.17.8.dev";

  src = fetchurl {
    url = "https://github.com/hiddify/hiddify-next/releases/download/${version}/Hiddify-Linux-x64.AppImage";
    hash = "sha256-T4BWxhJ7q13KE1rvvFsnXhs2XVEmNkFTJbJ4e8PCg+0=";
  };
  extraPkgs = pkgs:
    with pkgs; [
      libepoxy
    ];

}

# {
#   lib
# , stdenv
# , fetchFromGitHub
# , flutter
# }:

# flutter.buildFlutterApplication rec {
#   pname = "hiddify-next";
#   version = "0.14.20";
#
#   src = fetchFromGitHub {
#     owner = "hiddify";
#     repo = "hiddify-next";
#     rev = "v${version}";
#     hash = "sha256-IDn2xAzsHpprI39qHBKTETNTa06RREg82Yg4d3bM0Sw=";
#     fetchSubmodules = true;
#   };
#
#   meta = with lib; {
#     description = "Multi-platform auto-proxy client, supporting Sing-box, X-ray, TUIC, Hysteria, Reality, Trojan, SSH etc. It’s an open-source, secure and ad-free";
#     homepage = "https://github.com/hiddify/hiddify-next";
#     changelog = "https://github.com/hiddify/hiddify-next/blob/${src.rev}/CHANGELOG.md";
#     license = licenses.cc-by-nc-sa-40;
#     maintainers = with maintainers; [ oluceps ];
#     mainProgram = "hiddify-next";
#     platforms = platforms.all;
#     broken = false;
#   };
# }
