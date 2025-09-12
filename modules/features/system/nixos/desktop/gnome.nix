{ inputs, ... }:
let
  inherit (inputs.cadence.lib) feature features;
  inherit (feature) nixos homeManager;

  cadence.dependencies = {
    "desktop" = [
      # Base deps
      "desktop/xserver"
    ];

    # Subfeatures
    "desktop[gnome]" = [
      "desktop"
      "gnome-settings"
    ];
  };

  flake.modules = features [
    (nixos "desktop[gnome]" (
      { pkgs, ... }:
      {
        services = {
          displayManager.gdm.enable = true;
          desktopManager.gnome.enable = true;
          udev.packages = [ pkgs.gnome-settings-daemon ];
        };
        environment.systemPackages =
          (with pkgs; [
            refine
            gnome-tweaks
            # for radio-kayra
            yt-dlp
            gst_all_1.gstreamer
          ])
          ++ (with pkgs.gnomeExtensions; [
            appindicator
            user-themes
            dash-to-dock
            blur-my-shell
            logo-menu
            gsconnect
            gnome-40-ui-improvements
            panel-corners
            paperwm
            radio-kayra
            burn-my-windows
            just-perfection
            search-light
            clipboard-indicator
            unite
          ]);

        environment.gnome.excludePackages = with pkgs; [
          epiphany
        ];
      }
    ))
    (homeManager "gnome-settings" (
      { lib, ... }:

      with lib.hm.gvariant;

      {
        programs.gnome-shell.enable = true;
        dconf.settings = {

          "org/gnome/desktop/break-reminders".selected-breaks = [
            "eyesight"
            "movement"
          ];

          "org/gnome/desktop/break-reminders/eyesight".play-sound = true;

          "org/gnome/desktop/break-reminders/movement" = {
            duration-seconds = mkUint32 300;
            interval-seconds = mkUint32 1800;
            play-sound = true;
          };

          "org/gnome/desktop/input-sources" = {
            sources = [
              (mkTuple [
                "xkb"
                "pl"
              ])
            ];
            xkb-options = [
              "caps:hyper"
              "terminate:ctrl_alt_bksp"
            ];
          };

          "org/gnome/desktop/interface" = {
            accent-color = "purple";
            clock-format = "24h";
            font-antialiasing = "rgba";
            font-hinting = "slight";
            show-battery-percentage = true;
            color-scheme = "prefer-dark";
          };

          "org/gnome/desktop/peripherals/touchpad" = {
            tap-to-click = true;
            two-finger-scrolling-enabled = true;
          };

          "org/gnome/desktop/sound".allow-volume-above-100-percent = true;

          "org/gnome/desktop/wm/keybindings" = {
            close = [ "<Super>q" ];
          };

          "org/gnome/evince/default" = {
            continuous = false;
            dual-page = true;
            sizing-mode = "fit-page";
          };

          "org/gnome/settings-daemon/plugins/color" = {
            night-light-enabled = true;
            night-light-schedule-automatic = true;
          };

          "org/gnome/settings-daemon/plugins/media-keys" = {
            custom-keybindings = [
              "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
            ];
          };

          "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
            binding = "<Control><Alt>t";
            command = "foot";
            name = "Terminal";
          };

          "org/gnome/shell" = {
            enabled-extensions = [
              "appindicatorsupport@rgcjonas.gmail.com"
              "user-theme@gnome-shell-extensions.gcampax.github.com"
              "paperwm@paperwm.github.com"
            ];
            # TODO
            #
            # favorite-apps = [
            #   "org.gnome.Epiphany.desktop"
            #   "org.gnome.Geary.desktop"
            #   "org.gnome.Calendar.desktop"
            #   "org.gnome.Music.desktop"
            #   "org.gnome.Nautilus.desktop"
            #   "discord.desktop"
            # ];
          };

          "org/gnome/shell/keybindings" = {
            screenshot = [ "Print" ];
            screenshot-window = [ "<Alt>Print" ];
            show-screenshot-ui = [ "<Shift><Alt>5" ];
          };

          "org/gnome/shell/world-clocks" = {
            locations = [ ];
          };

          "org/gnome/tweaks" = {
            show-extensions-notice = false;
          };

          "system/locale" = {
            # TODO
            region = "en_DK.UTF-8";
          };

        };
      }
    ))

  ];
in
{
  inherit cadence flake;
}
