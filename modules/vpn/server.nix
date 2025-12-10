{ config, lib, pkgs, ... }:
let
  cfg = config.vpn.server;
  secrets =
    if builtins.pathExists cfg.secretsFile
    then (pkgs.formats.yaml {}).load cfg.secretsFile
    else throw "vpn.server: secrets file not found at ${cfg.secretsFile}. Run `just decrypt-secrets` before building.";
  basicAuth = secrets.traefik-basicauth or "";
  basicAuthFile = pkgs.writeText "traefik-basicauth" basicAuth;
in
{
  options.vpn.server = {
    enable = lib.mkEnableOption "VPN server stack (Traefik, x-ui upstream)";
    domain = lib.mkOption {
      type = lib.types.str;
      default = "dorekhov.xyz";
      description = "Domain used for Traefik routing.";
    };
    secretsFile = lib.mkOption {
      type = lib.types.path;
      default = ../../secrets/secrets.decrypted.yaml;
      description = "Decrypted secrets YAML (gitignored). Run `just decrypt-secrets` to generate.";
    };
    acmeEmail = lib.mkOption {
      type = lib.types.str;
      default = "daniil.orekhov15@gmail.com";
      description = "Email for ACME/Let's Encrypt registration.";
    };
  };

  config = lib.mkIf cfg.enable {
    # Traefik reverse proxy for /x-ui
    services.traefik = {
      enable = true;
      dynamicConfigOptions = {
        http = {
          routers = {
            panel = {
              entryPoints = [ "websecure" ];
              rule = "Host(`''${cfg.domain}``) && PathPrefix(`/x-ui`)";
              tls = {
                certResolver = "letsencrypt";
              };
              service = "panel";
              middlewares = [ "https-redirect@file" "strip-xui@file" "auth@file" ];
            };
            panel-http-redirect = {
              entryPoints = [ "web" ];
              rule = "Host(`''${cfg.domain}``) && PathPrefix(`/x-ui`)";
              service = "noop";
              middlewares = [ "https-redirect@file" ];
            };
          };
          services.panel.loadBalancer.servers = [
            { url = "http://127.0.0.1:54321"; }
          ];
          services.noop.loadBalancer.servers = [
            { url = "http://127.0.0.1:54321"; }
          ];
          middlewares.https-redirect.redirectScheme = {
            scheme = "https";
            permanent = true;
          };
          middlewares.strip-xui.stripPrefix.prefixes = [ "/x-ui" ];
          middlewares.auth.basicauth = {
            usersFile = basicAuthFile;
            removeHeader = true;
          };
        };
      };
      staticConfigOptions = {
        entryPoints = {
          web = {
            address = ":80";
          };
          websecure = {
            address = ":443";
          };
        };
        certificatesResolvers.letsencrypt.acme = {
          email = cfg.acmeEmail;
          storage = "/var/lib/traefik/acme.json";
          httpChallenge.entryPoint = "web";
        };
      };
    };

    networking.firewall = {
      allowedTCPPorts = lib.mkAfter [ 80 443 ];
      allowedUDPPorts = lib.mkAfter [ 443 ];
    };
  };
}

