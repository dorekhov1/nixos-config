{ config, lib, pkgs, ... }:

let
  version = "0.2.53";
  srcSha256 = "gcxoRLNYuHMC/yeGRjAUx2UBnJOgwF+u6FiCi5NpIbU=";

  # Using the original implementation with mkDerivation instead of buildNpmPackage
  claude-code = pkgs.stdenv.mkDerivation rec {
    pname = "claude-code";
    inherit version;
    
    src = pkgs.fetchurl {
      url = "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-${version}.tgz";
      sha256 = srcSha256;
    };
    
    nativeBuildInputs = with pkgs; [ nodejs makeWrapper ];
    
    unpackPhase = ''
      mkdir -p package
      tar -xzf $src -C package
    '';
    
    dontBuild = true;
    
    installPhase = ''
      mkdir -p $out/lib/node_modules/@anthropic-ai/claude-code
      cp -r package/. $out/lib/node_modules/@anthropic-ai/claude-code/
      
      mkdir -p $out/bin
      
      # Create wrapper for claude command that points to cli.js
      makeWrapper ${pkgs.nodejs}/bin/node $out/bin/claude \
        --add-flags "$out/lib/node_modules/@anthropic-ai/claude-code/package/cli.js" \
        --set HTTP_PROXY "http://127.0.0.1:2334" \
        --set HTTPS_PROXY "http://127.0.0.1:2334" \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [
          pkgs.stdenv.cc.cc.lib
          pkgs.icu
        ]}
      
      # Also create a claude-code symlink for compatibility
      ln -s $out/bin/claude $out/bin/claude-code
    '';
    
    meta = with lib; {
      description = "Claude Code CLI";
      homepage = "https://www.anthropic.com";
      license = licenses.mit;
      platforms = platforms.all;
      mainProgram = "claude";
    };
  };
in
{
  environment.systemPackages = [
    claude-code
  ];
}
