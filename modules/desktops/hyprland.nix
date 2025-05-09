{ config, lib, pkgs, inputs, ... }:
let

  inherit (lib) mkEnableOption mkOption mkIf mkMerge types mapAttrsToList;
in{

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  home-manager.users.${config.user}.home = {
    packages = with pkgs; [ 
        waybar
        swww
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      settings = let
        playerctl = "${pkgs.playerctl}/bin/playerctl";
        pactl = "${pkgs.pulseaudio}/bin/pactl";
        pamixer = "${pkgs.pamixer}/bin/pamixer";
      in {
        bezier = [
          "mycurve,.32,.97,.53,.98"
          "expoOut,0.19,1.0,0.22,1.0"
          "overshot,.32,.97,.37,1.16"
          "easeInOut,.5,0,.5,1"
        ];
        env = mapAttrsToList (name: value: "${name},${toString value}") {
          WLR_NO_HARDWARE_CURSORS = 1; # For Sunshine... Let's see if I notice anything...
          SDL_VIDEODRIVER = "wayland";
          _JAVA_AWT_WM_NONREPARENTING = 1;
          WLR_DRM_NO_ATOMIC = 1;
          XCURSOR_SIZE = 24;
          CLUTTER_BACKEND = "wayland";
          XDG_SESSION_TYPE = "wayland";
          QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
          MOZ_ENABLE_WAYLAND = "1";
          WLR_BACKEND = "vulkan";
          QT_QPA_PLATFORM = "wayland";
          GDK_BACKEND = "wayland";
          TERM = "wezterm";
          NIXOS_OZONE_WL = "1";
        };
        layerrule = [
          "noanim, ^(selection)$"
          "blur,^(anyrun)$"
        ];
      misc = {
          vfr = true;
          enable_swallow = true;
          swallow_regex = "^(foot)$";
          animate_manual_resizes = true;
          force_default_wallpaper = 0;
        };
        input = {
          follow_mouse = 1;
          force_no_accel = 1;
          repeat_delay = 200;
          repeat_rate = 40;

          touchpad = {
            natural_scroll = false;
          };
          kb_layout = config.services.xserver.xkb.layout;
        };
        general = {
          sensitivity = 0.2;

          gaps_in = 1;
          gaps_out = 2;
          border_size = 1;
          allow_tearing = true;

          layout = "dwindle";
        };
        binds = {
          workspace_back_and_forth = 0;
          allow_workspace_cycles = 1;
        };
        decoration = {
          rounding = 0;
          dim_inactive = true;
          dim_strength = 0.2;
          drop_shadow = 1;
          shadow_range = 20;
          shadow_render_power = 2;
          "col.shadow" = "rgba(00000044)";
          shadow_offset = "0 0";
          blur = {
            enabled = 1;
            size = 4;
            passes = 4;
            ignore_opacity = 1;
            xray = 1;
            new_optimizations = 1;
            noise = 0.03;
            contrast = 1.0;
          };
        };
        animations = {
          enabled = 1;
          animation = [
            "windowsMove,0,4,expoOut"
            "windowsIn,0,4,expoOut"
            "windowsOut,0,4,mycurve"
            "fadeIn,0,3,mycurve"
            "fadeOut,1,3,mycurve"
            "fadeDim,1,1,expoOut"
            "border,1,4,expoOut"
            "workspaces,0,2,expoOut,fade"
          ];
        };
        dwindle = {
          pseudotile = 0;
          force_split = 2;
          preserve_split = 1;
          default_split_ratio = 1.3;
        };
        master = {
          new_is_master = false;
          new_on_top = false;
          no_gaps_when_only = false;
          orientation = "top";
          mfact = 0.6;
          always_center_master = false;
        };
        exec-once = [
          "${pkgs.mako}/bin/mako"
          "${pkgs.foot}/bin/foot --server"
          # "${elib.flPkgs inputs.flutter_background_bar}/bin/flutter_background_bar"
          "hyprctl setcursor Bibata-Modern-Ice 24"

          "${pkgs.wl-clipboard}/bin/wl-paste --type text --watch ${pkgs.cliphist}/bin/cliphist store #Stores only text data"
          "${pkgs.wl-clipboard}/bin/wl-paste --type text --watch ${pkgs.xclip}/bin/xclip -selection clipboard"
          "${pkgs.wl-clipboard}/bin/wl-paste --type image --watch ${pkgs.cliphist}/bin/cliphist store #Stores only image data"
          "${pkgs.snapcast}/bin/snapclient --host 10.0.0.2 -s 3 --port 1704"
          # "[workspace special] firefox"
        ];
        bind = [
          '',Print,exec,${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.wl-clipboard}/bin/wl-copy -t image/png''
          "ALT,S,fullscreen"
          "ALT,F,exec,${pkgs.foot}/bin/foot"
          "ALT,V,exec,${pkgs.foot}/bin/footclient --app-id sideterm"
          "ALT,BACKSPACE,exec,${pkgs.foot}/bin/footclient --app-id middleterm"
          "ALT,D,killactive,"
          "ALT,G,togglefloating,"
          ",Menu,exec,hyprctl switchxkblayout kmonad-kb-laptop next && hyprctl switchxkblayout kmonad-kb-hyperx next"

          "ALT,SEMICOLON,exec,anyrun"

          "SHIFTALT,SEMICOLON,exit,"
          "ALT,A,togglesplit,"

          ",XF86AudioPlay,exec,${playerctl} play-pause"
          ",XF86AudioPrev,exec,${playerctl} previous"
          ",XF86AudioNext,exec,${playerctl} next"

          "ALT,H,movefocus,l"
          "ALT,J,movefocus,d"
          "ALT,K,movefocus,u"
          "ALT,L,movefocus,r"

          "ALTCTRL,L,swapwindow,r"
          "ALTCTRL,H,swapwindow,l"
          "ALTCTRL,K,swapwindow,u"
          "ALTCTRL,J,swapwindow,d"

          "SUPER,U,workspace,previous"
          "ALT,Q,workspace,1"
          "ALT,W,workspace,2"
          "ALT,E,workspace,3"
          "ALT,R,workspace,4"
          "ALT,T,workspace,5"
          "ALT,Y,workspace,6"
          "ALT,U,workspace,7"
          "ALT,I,workspace,8"
          "ALT,O,workspace,9"
          "ALT,P,workspace,10"

          "ALTSHIFT,Q,movetoworkspace,1"
          "ALTSHIFT,W,movetoworkspace,2"
          "ALTSHIFT,E,movetoworkspace,3"
          "ALTSHIFT,R,movetoworkspace,4"
          "ALTSHIFT,T,movetoworkspace,5"
          "ALTSHIFT,Y,movetoworkspace,6"
          "ALTSHIFT,U,movetoworkspace,7"
          "ALTSHIFT,I,movetoworkspace,8"
          "ALTSHIFT,O,movetoworkspace,9"
          "ALTSHIFT,P,movetoworkspace,10"
        ];
        binde = [
          "ALTSHIFT,H,resizeactive,-150 0"
          "ALTSHIFT,J,resizeactive,0 150"
          "ALTSHIFT,K,resizeactive,0 -150"
          "ALTSHIFT,L,resizeactive,150 0"

          ",XF86AudioRaiseVolume,exec,${pactl} set-sink-volume @DEFAULT_SINK@ +5% && ${pactl} get-sink-volume @DEFAULT_SINK@ | head -n 1 | awk '{print substr($5, 1, length($5)-1)}' > $WOBSOCK"
          ",XF86AudioLowerVolume,exec,${pactl} set-sink-volume @DEFAULT_SINK@ -5% && ${pactl} get-sink-volume @DEFAULT_SINK@ | head -n 1 | awk '{print substr($5, 1, length($5)-1)}' > $WOBSOCK"
          '',XF86AudioMute,exec,${pamixer} --toggle-mute && ( [ "$(${pamixer} --get-mute)" = "true" ] && echo 0 > $WOBSOCK ) || ${pamixer} --get-volume > $WOBSOCK''

          ",XF86MonBrightnessUp,exec,${pkgs.lib.getExe pkgs.brightnessctl} set +5%"
          ",XF86MonBrightnessDown,exec,${pkgs.lib.getExe pkgs.brightnessctl} set 5%-"
        ];
        bindm = [
          "ALT,mouse:272,movewindow"
          "ALT,mouse:273,resizewindow"
        ];
        windowrulev2 = let
          rulesForWindow = window: map (rule: "${rule},${window}");
        in
          []
          # Specific window rules
          ++ (rulesForWindow "title:^()$,class:^(steam)$" ["stayfocused" "minsize 1 1"])
          ++ (rulesForWindow "class:^(sideterm)$" ["float" "move 60% 10" "size 750 350" "animation slide"])
          ++ (rulesForWindow "class:^(looking-glass-client)$" ["immediate"])
          ++ (rulesForWindow "class:^(middleterm)$" ["float" "size 750 550" "animation slide"])
          ++ (rulesForWindow "class:^(guifetch)$" ["float" "animation slide" "move 10 10"])
          ++ (rulesForWindow "class:^(listen_blue)$" ["size 813 695" "float" "center"])
          ++ (rulesForWindow "class:^(neovide)$" ["tile"])
          ++ (rulesForWindow "class:^(firefox)$" ["opacity 0.999 0.999"])
          # General window rules
          ++ (rulesForWindow "floating:0" ["rounding 0"])
          ++ (rulesForWindow "floating:1" ["rounding 5"])
          ++ (rulesForWindow "floating:0" ["noshadow"]);
      };
    };
  };
}
