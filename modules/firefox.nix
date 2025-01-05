{ pkgs, config, ... }: {

  home-manager.users.${config.user} = {

    programs.firefox = {
      enable = true;
      

      # Configure Firefox settings
      profiles.default = {
        id = 0;
        name = "Default";
        isDefault = true;
        
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          bitwarden
          darkreader
          privacy-badger
        ];

        settings = {
          # Enable hardware video acceleration
          "media.ffmpeg.vaapi.enabled" = true;
          "media.navigator.mediadatadecoder_vpx_enabled" = true;

          # Privacy settings
          # "privacy.trackingprotection.enabled" = true;
          # "privacy.donottrackheader.enabled" = true;
          # "privacy.resistFingerprinting" = true;
          # "privacy.firstparty.isolate" = true;

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
          # "browser.toolbars.bookmarks.visibility" = "always";
          # "browser.theme.content-theme" = 0;
          # "browser.theme.toolbar-theme" = 0;
          
          # Downloads
          # "browser.download.dir" = "/home/yourusername/Downloads";
          # "browser.download.folderList" = 2;

          # Other preferences
          # "browser.startup.homepage" = "https://start.duckduckgo.com";
          # "browser.search.defaultenginename" = "DuckDuckGo";
          # "browser.search.isUS" = false;
          # "general.useragent.locale" = "en-US";
        };

        # # Custom user Chrome CSS
        # userChrome = ''
        #   /* Add your custom CSS here */
        # '';
        #
        # # Custom user Content CSS
        # userContent = ''
        #   /* Add your custom CSS here */
        # '';

        # Search engines
        search = {
          force = true;
          default = "DuckDuckGo";
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
              iconUpdateURL = "https://nixos.wiki/favicon.png";
              updateInterval = 24 * 60 * 60 * 1000; # every day
              definedAliases = [ "@nw" ];
            };
            "Bing".metaData.hidden = true;
            "Google".metaData.alias = "@g"; # create a @g alias
          };
        };

        # Bookmarks
        bookmarks = [
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
    };
  };
}
