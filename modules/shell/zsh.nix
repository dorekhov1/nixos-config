{ config, pkgs, lib, ... }:

{

  home-manager.users.${config.user} = {
  
    programs = {
      zsh = {
        enable = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        enableCompletion = true;
  
        dotDir = "/home/${config.user}/.config/zsh";
        plugins = [
          {
            name = "zsh-nix-shell";
            file = "nix-shell.plugin.zsh";
            src = pkgs.fetchFromGitHub {
              owner = "chisui";
              repo = "zsh-nix-shell";
              rev = "v0.8.0";
              sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
            };
          }
        ]; 

        initContent =
          let
            enableProxy = (config.networking.hostName or "") != "vps";
          in lib.optionalString enableProxy ''
            proxy_http="http://127.0.0.1:2334"
            proxy_socks="socks5://127.0.0.1:2334"

            set_proxy() {
              export http_proxy="$proxy_http"
              export https_proxy="$proxy_http"
              export ALL_PROXY="$proxy_socks"
              export no_proxy="$no_proxy_addr"
            }

            unset_proxy() {
              unset http_proxy
              unset https_proxy
              unset ALL_PROXY
              unset no_proxy
            }

            toggle_proxy() {
              if [[ -n "$http_proxy" ]]; then
                unset_proxy
                echo "Proxy settings have been disabled."
              else
                set_proxy
                echo "Proxy settings have been enabled."
              fi
            }

            check_proxy() {
              if [[ -n "$http_proxy" ]]; then
                echo "Proxy is currently set to:"
                echo "HTTP_PROXY: $http_proxy"
                echo "HTTPS_PROXY: $https_proxy"
                echo "ALL_PROXY: $ALL_PROXY"
                echo "NO_PROXY: $no_proxy"
              else
                echo "Proxy is currently disabled."
              fi
            }

            set_proxy
          '';
      };
    };
  };
}
