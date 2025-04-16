{ pkgs, config, ... }: {

  home-manager.users.${config.user} = {

    programs.firefox = {
      enable = true;
      

      # Configure Firefox settings
      profiles.default = {
        id = 0;
        name = "Default";
        isDefault = true;
        
        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          bitwarden
          darkreader
          privacy-badger
        ];

        settings = {
          # Enable hardware video acceleration
          "media.ffmpeg.vaapi.enabled" = true;
          "media.navigator.mediadatadecoder_vpx_enabled" = true;

          # Disable telemetry
          "browser.newtabpage.activity-stream.feeds.telemetry" = false;
          "browser.ping-centre.telemetry" = false;
          "browser.tabs.crashReporting.sendReport" = false;
          "devtools.onboarding.telemetry.logged" = false;
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.unified" = false;

          # Performance settings
          "browser.cache.disk.enable" = false;
          "browser.cache.memory.enable" = true;
          "browser.cache.memory.capacity" = 524288;
          "browser.sessionstore.interval" = 15000;

          # UI customization
          "sidebar.verticalTabs" = true;

          # Disable password saving prompts
          "signon.rememberSignons" = false;
          "signon.autofillForms" = false;

          # Disable translation prompts
          "browser.translation.ui.show" = false;
          "browser.translation.detectLanguage" = false;

          # Enable dark theme
          "browser.theme.content-theme" = 0;
          "browser.theme.toolbar-theme" = 0;
          "browser.in-content.dark-mode" = true;
          "ui.systemUsesDarkTheme" = 1;
          "layout.css.prefers-color-scheme.content-override" = 0;

          # Performance improvements
          # Increase process count for better parallel processing
          "dom.ipc.processCount" = 8;  # Default is 8, increase if you have more CPU cores

          # Enable HTTP/3 for faster connections
          "network.http.http3.enabled" = true;

          # Reduce animation effects
          "ui.prefersReducedMotion" = 1;

          # Enable hardware acceleration
          "gfx.webrender.all" = true;
          "layers.acceleration.force-enabled" = true;

          # Memory management
          "browser.tabs.unloadOnLowMemory" = true;

          # Increase script timeout for complex web apps
          "dom.max_script_run_time" = 20;  # Default is 10 seconds

          # Enable back-forward cache for faster navigation
          "browser.cache.memory.max_entry_size" = 51200;

          # Reduce resource usage of background tabs
          "browser.tabs.loadInBackground" = false;
          "browser.sessionstore.interval.idle" = 3600000; # Save session every hour when idle

          # Enable process per site isolation for better stability
          "fission.autostart" = true;

          # Optimize JavaScript performance
          "javascript.options.mem.gc_incremental_slice_ms" = 5;
          "javascript.options.mem.high_water_mark" = 128;

          # Additional SSE-specific optimizations
          "network.http.connection-timeout" = 300;  # Longer connection timeout
          "network.http.response.timeout" = 300;    # Longer response timeout
          "network.http.max-persistent-connections-per-server" = 10;  # More concurrent connections
        };

        # Search engines
        search = {
          force = true;
          default = "ddg";  # Changed from "DuckDuckGo"
          engines = {
            "Nix Packages" = {
              urls = [{
                template = "https://search.nixos.org/packages";
                params = [
                  { name = "type"; value = "packages"; }
                  { name = "query"; value = "{searchTerms}"; }
                ];
              }];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@np" ];
            };
            "NixOS Wiki" = {
              urls = [{
                template = "https://nixos.wiki/index.php?search={searchTerms}";
              }];
              icon = "https://nixos.wiki/favicon.png";  # Changed from iconUpdateURL
              updateInterval = 24 * 60 * 60 * 1000; # every day
              definedAliases = [ "@nw" ];
            };
            "bing".metaData.hidden = true;  # Changed from "Bing"
            "google".metaData.alias = "@g"; # Changed from "Google"
          };
        };

        # Bookmarks
        bookmarks = {
          force = true;  # Added as required by new format
          settings = [
            {
              name = "NixOS";
              tags = [ "nix" "os" ];
              keyword = "nixos";
              url = "https://nixos.org/";
            }
            {
              name = "Home-Manager";
              url = "https://nix-community.github.io/home-manager/";
              tags = [ "nix" "home-manager" ];
            }
            {
              name = "Development";
              toolbar = true;
              bookmarks = [
                {
                  name = "GitHub";
                  url = "https://github.com/";
                }
                {
                  name = "NixOS Search";
                  url = "https://search.nixos.org/";
                }
              ];
            }
          ];
        };

        userChrome = ''
          #Bitwarden_toolbar-button {
            -moz-box-ordinal-group: 1 !important;
          }
        '';

      };
    };
  };
}
