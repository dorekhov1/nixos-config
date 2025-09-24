#
#  KDE Plasma 5 Configuration
#  Enable with "kde.enable = true;"
#  Get the plasma configs in a file with $ nix run github:pjones/plasma-manager > <file>
#

{ config, lib, pkgs, inputs, ... }:

with lib;
{
  options = {
    kde = {
      enable = mkOption {
        type = types.bool;
        default = true;
      };
    };
  };

  config = mkIf (config.kde.enable) {
    programs = {
      zsh.enable = true;
    };

    services = {
      libinput.enable = true;
      displayManager = {
        sddm.enable = true;                       # Display Manager
      };

      desktopManager = {
        plasma6.enable = true;                       # Desktop Manager
      };

      xserver = {
        enable = true;

        xkb = {
          layout = "us,us,ru";
          variant = ",dvp,";
          options = "grp:win_space_toggle";
        };

        modules = [ pkgs.xf86_input_wacom ];
        wacom.enable = true;

      };
      pipewire = {
        enable = true;
        alsa.enable = true;
        pulse.enable = true;
      };
    };


    # environment = {
    #   systemPackages = with pkgs.libsForQt5; [      # System-Wide Packages
    #     # bismuth         # Dynamic Tiling
    #     # packagekit-qt   # Package Updater
    #   ];
    #   plasma6.excludePackages = with pkgs.libsForQt5; [
    #     # elisa
    #     # khelpcenter
    #     # konsole
    #     # oxygen
    #   ];
    # };

    home-manager.users.${config.user} = {
      # KDE Theme settings
      home.file.".config/kdeglobals".text = ''
        [$Version]
        update_info=icons_remove_effects.upd:IconsRemoveEffects,style_widgetstyle_default_breeze.upd:StyleWidgetStyleDefaultBreeze,kwin.upd:animation-speed,filepicker.upd:filepicker-remove-old-previews-entry,fonts_global.upd:Fonts_Global,fonts_global_toolbar.upd:Fonts_Global_Toolbar

        [ColorEffects:Disabled]
        ChangeSelectionColor=
        Color=56,56,56
        ColorAmount=0
        ColorEffect=0
        ContrastAmount=0.65
        ContrastEffect=1
        Enable=
        IntensityAmount=0.1
        IntensityEffect=2

        [ColorEffects:Inactive]
        ChangeSelectionColor=true
        Color=112,111,110
        ColorAmount=0.025
        ColorEffect=2
        ContrastAmount=0.1
        ContrastEffect=2
        Enable=false
        IntensityAmount=0
        IntensityEffect=0

        [Colors:Button]
        BackgroundAlternate=30,87,116
        BackgroundNormal=49,54,59
        DecorationFocus=61,174,233
        DecorationHover=61,174,233
        ForegroundActive=61,174,233
        ForegroundInactive=161,169,177
        ForegroundLink=29,153,243
        ForegroundNegative=218,68,83
        ForegroundNeutral=246,116,0
        ForegroundNormal=252,252,252
        ForegroundPositive=39,174,96
        ForegroundVisited=155,89,182

        [Colors:Complementary]
        BackgroundAlternate=30,87,116
        BackgroundNormal=42,46,50
        DecorationFocus=61,174,233
        DecorationHover=61,174,233
        ForegroundActive=61,174,233
        ForegroundInactive=161,169,177
        ForegroundLink=29,153,243
        ForegroundNegative=218,68,83
        ForegroundNeutral=246,116,0
        ForegroundNormal=252,252,252
        ForegroundPositive=39,174,96
        ForegroundVisited=155,89,182

        [Colors:Header]
        BackgroundAlternate=42,46,50
        BackgroundNormal=49,54,59
        DecorationFocus=61,174,233
        DecorationHover=61,174,233
        ForegroundActive=61,174,233
        ForegroundInactive=161,169,177
        ForegroundLink=29,153,243
        ForegroundNegative=218,68,83
        ForegroundNeutral=246,116,0
        ForegroundNormal=252,252,252
        ForegroundPositive=39,174,96
        ForegroundVisited=155,89,182

        [Colors:Header][Inactive]
        BackgroundAlternate=49,54,59
        BackgroundNormal=42,46,50
        DecorationFocus=61,174,233
        DecorationHover=61,174,233
        ForegroundActive=61,174,233
        ForegroundInactive=161,169,177
        ForegroundLink=29,153,243
        ForegroundNegative=218,68,83
        ForegroundNeutral=246,116,0
        ForegroundNormal=252,252,252
        ForegroundPositive=39,174,96
        ForegroundVisited=155,89,182

        [Colors:Selection]
        BackgroundAlternate=30,87,116
        BackgroundNormal=61,174,233
        DecorationFocus=61,174,233
        DecorationHover=61,174,233
        ForegroundActive=252,252,252
        ForegroundInactive=161,169,177
        ForegroundLink=253,188,75
        ForegroundNegative=176,55,69
        ForegroundNeutral=198,92,0
        ForegroundNormal=252,252,252
        ForegroundPositive=23,104,57
        ForegroundVisited=155,89,182

        [Colors:Tooltip]
        BackgroundAlternate=42,46,50
        BackgroundNormal=49,54,59
        DecorationFocus=61,174,233
        DecorationHover=61,174,233
        ForegroundActive=61,174,233
        ForegroundInactive=161,169,177
        ForegroundLink=29,153,243
        ForegroundNegative=218,68,83
        ForegroundNeutral=246,116,0
        ForegroundNormal=252,252,252
        ForegroundPositive=39,174,96
        ForegroundVisited=155,89,182

        [Colors:View]
        BackgroundAlternate=35,38,41
        BackgroundNormal=27,30,32
        DecorationFocus=61,174,233
        DecorationHover=61,174,233
        ForegroundActive=61,174,233
        ForegroundInactive=161,169,177
        ForegroundLink=29,153,243
        ForegroundNegative=218,68,83
        ForegroundNeutral=246,116,0
        ForegroundNormal=252,252,252
        ForegroundPositive=39,174,96
        ForegroundVisited=155,89,182

        [Colors:Window]
        BackgroundAlternate=49,54,59
        BackgroundNormal=42,46,50
        DecorationFocus=61,174,233
        DecorationHover=61,174,233
        ForegroundActive=61,174,233
        ForegroundInactive=161,169,177
        ForegroundLink=29,153,243
        ForegroundNegative=218,68,83
        ForegroundNeutral=246,116,0
        ForegroundNormal=252,252,252
        ForegroundPositive=39,174,96
        ForegroundVisited=155,89,182

        [General]
        ColorSchemeHash=2ef8a9f7238e072ca91b0eb590f49ded650c76bd

        [KDE]
        LookAndFeelPackage=org.kde.breezedark.desktop

        [WM]
        activeBackground=49,54,59
        activeBlend=252,252,252
        activeForeground=252,252,252
        inactiveBackground=42,46,50
        inactiveBlend=161,169,177
        inactiveForeground=161,169,177
      '';

      home.file.".config/plasma-org.kde.plasma.desktop-appletsrc".text = ''
        [ActionPlugins][0]
        RightButton;NoModifier=org.kde.contextmenu
        wheel:Vertical;NoModifier=org.kde.switchdesktop
        [ActionPlugins][1]
        RightButton;NoModifier=org.kde.contextmenu
        [Containments][1]
        ItemGeometries-1920x1080=
        ItemGeometriesHorizontal=
        activityId=aaaa8581-3bc3-4351-a53e-7555c5629bd3
        formfactor=0
        immutability=1
        lastScreen=0
        location=0
        plugin=org.kde.plasma.folder
        wallpaperplugin=org.kde.image
        [Containments][2]
        activityId=
        formfactor=2
        immutability=1
        lastScreen=0
        location=4
        plugin=org.kde.panel
        wallpaperplugin=org.kde.image
        [Containments][2][Applets][18]
        immutability=1
        plugin=org.kde.plasma.digitalclock
        [Containments][2][Applets][19]
        immutability=1
        plugin=org.kde.plasma.showdesktop
        [Containments][2][Applets][3]
        immutability=1
        plugin=org.kde.plasma.kickoff
        [Containments][2][Applets][3][Configuration]
        PreloadWeight=100
        popupHeight=514
        popupWidth=651
        [Containments][2][Applets][3][Configuration][General]
        favoritesPortedToKAstats=true
        [Containments][2][Applets][3][Configuration][Shortcuts]
        global=Alt+F1
        [Containments][2][Applets][3][Shortcuts]
        global=Alt+F1
        [Containments][2][Applets][4]
        immutability=1
        plugin=org.kde.plasma.pager
        [Containments][2][Applets][5]
        immutability=1
        plugin=org.kde.plasma.icontasks
        [Containments][2][Applets][5][Configuration][General]
        launchers=applications:org.kde.dolphin.desktop,applications:firefox.desktop,applications:org.wezfurlong.wezterm.desktop,applications:org.telegram.desktop.desktop,applicatins:cursor.desktop
        [Containments][2][Applets][6]
        immutability=1
        plugin=org.kde.plasma.marginsseparator
        [Containments][2][Applets][7]
        immutability=1
        plugin=org.kde.plasma.systemtray
        [Containments][2][Applets][7][Configuration]
        PreloadWeight=60
        SystrayContainmentId=8
        [Containments][2][General]
        AppletOrder=3;4;5;6;7;18;19
        [PlasmaViews][Panel 2][Defaults]
        thickness=46
        [Containments][8]
        activityId=
        formfactor=2
        immutability=1
        lastScreen=0
        location=4
        plugin=org.kde.plasma.private.systemtray
        popupHeight=432
        popupWidth=432
        wallpaperplugin=org.kde.image
        [Containments][8][Applets][10]
        immutability=1
        plugin=org.kde.plasma.devicenotifier
        [Containments][8][Applets][11]
        immutability=1
        plugin=org.kde.plasma.manage-inputmethod
        [Containments][8][Applets][12]
        immutability=1
        plugin=org.kde.plasma.notifications
        [Containments][8][Applets][13]
        immutability=1
        plugin=org.kde.kscreen
        [Containments][8][Applets][14]
        immutability=1
        plugin=org.kde.plasma.keyboardindicator
        [Containments][8][Applets][15]
        immutability=1
        plugin=org.kde.plasma.keyboardlayout
        [Containments][8][Applets][16]
        immutability=1
        plugin=org.kde.plasma.printmanager
        [Containments][8][Applets][17]
        immutability=1
        plugin=org.kde.plasma.volume
        [Containments][8][Applets][17][Configuration][General]
        migrated=true
        [Containments][8][Applets][20]
        immutability=1
        plugin=org.kde.plasma.nightcolorcontrol
        [Containments][8][Applets][21]
        immutability=1
        plugin=org.kde.plasma.battery
        [Containments][8][Applets][22]
        immutability=1
        plugin=org.kde.plasma.networkmanagement
        [Containments][8][Applets][22][Configuration]
        PreloadWeight=55
        [Containments][8][Applets][23]
        immutability=1
        plugin=org.kde.plasma.bluetooth
        [Containments][8][Applets][9]
        immutability=1
        plugin=org.kde.plasma.clipboard
        [Containments][8][General]
        extraItems=org.kde.plasma.battery,org.kde.plasma.clipboard,org.kde.plasma.devicenotifier,org.kde.plasma.manage-inputmethod,org.kde.plasma.mediacontroller,org.kde.plasma.notifications,org.kde.kscreen,org.kde.plasma.bluetooth,org.kde.plasma.keyboardindicator,org.kde.plasma.keyboardlayout,org.kde.plasma.networkmanagement,org.kde.plasma.nightcolorcontrol,org.kde.plasma.printmanager,org.kde.plasma.volume
        knownItems=org.kde.plasma.battery,org.kde.plasma.clipboard,org.kde.plasma.devicenotifier,org.kde.plasma.manage-inputmethod,org.kde.plasma.mediacontroller,org.kde.plasma.notifications,org.kde.kscreen,org.kde.plasma.bluetooth,org.kde.plasma.keyboardindicator,org.kde.plasma.keyboardlayout,org.kde.plasma.networkmanagement,org.kde.plasma.nightcolorcontrol,org.kde.plasma.printmanager,org.kde.plasma.volume
        [ScreenMapping]
        itemsOnDisabledScreens=
        screenMapping=
      '';

      home.file.".config/kxkbrc".text = ''
        [$Version]
        update_info=kxkb.upd:remove-empty-lists,kxkb.upd:add-back-resetoptions,kxkb_variants.upd:split-variants

        [Layout]
        DisplayNames=,dvp,
        LayoutList=us,us,ru
        Use=true
        VariantList=,dvp,
      '';
    };

  };
}
