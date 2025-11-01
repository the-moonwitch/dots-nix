{ lib, ... }:
{
  flake.aspects."system/nixos/gnome" = {
    nixos =
      { pkgs, ... }:
      {
        services = {
          displayManager.gdm.enable = lib.mkDefault true;
          desktopManager.gnome.enable = lib.mkDefault true;
          udev.packages = lib.mkDefault [ pkgs.gnome-settings-daemon ];
        };
        environment.systemPackages = lib.mkDefault (
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
            gsconnect
            gnome-40-ui-improvements
            panel-corners
            paperwm
            burn-my-windows
            search-light
            clipboard-indicator
            unite
          ])
        );

        environment.gnome.excludePackages = lib.mkDefault (with pkgs; [ epiphany ]);

        systemd.services = {
          "getty@tty1".enable = lib.mkDefault false;
          "autovt@tty1".enable = lib.mkDefault false;
        };
      };

    homeManager =
      {
        lib,
        hostDef,
        config,
        ...
      }:

      let
        bmw_config = "${config.xdg.configHome}/burn-my-windows/profiles/${hostDef.username}.conf";
        gtk4_css = "${config.xdg.configHome}/gtk-4.0/gtk.css";
      in
      {
        programs.gnome-shell.enable = lib.mkDefault true;
        gtk.gtk4.extraCss = lib.mkDefault "@import url('/run/current-system/sw/share/gnome-shell/extensions/unite@hardpixel.eu/styles/gtk4/buttons-right/always.css'";
        home.file."${gtk4_css}".force = lib.mkForce true;

        dconf.settings = with lib.hm.gvariant; {

          "org/gnome/desktop/break-reminders".selected-breaks = lib.mkDefault [
            "eyesight"
            "movement"
          ];

          "org/gnome/desktop/break-reminders/eyesight".play-sound = lib.mkDefault true;

          "org/gnome/desktop/break-reminders/movement" = {
            duration-seconds = lib.mkDefault (mkUint32 300);
            interval-seconds = lib.mkDefault (mkUint32 1800);
            play-sound = lib.mkDefault true;
          };

          "org/gnome/desktop/input-sources" = {
            sources = lib.mkDefault [
              (mkTuple [
                "xkb"
                "pl"
              ])
            ];
            xkb-options = lib.mkDefault [
              "caps:hyper"
              "terminate:ctrl_alt_bksp"
            ];
          };

          "org/gnome/desktop/interface" = {
            accent-color = lib.mkDefault "purple";
            clock-format = lib.mkDefault "24h";
            font-antialiasing = lib.mkDefault "rgba";
            font-hinting = lib.mkDefault "slight";
            show-battery-percentage = lib.mkDefault true;
            color-scheme = lib.mkDefault "prefer-dark";
          };

          "org/gnome/desktop/peripherals/touchpad" = {
            tap-to-click = lib.mkDefault true;
            two-finger-scrolling-enabled = lib.mkDefault true;
          };

          "org/gnome/desktop/sound".allow-volume-above-100-percent = lib.mkDefault true;

          "org/gnome/desktop/wm/keybindings" = {
            close = lib.mkDefault [ "<Super>q" ];
          };

          "org/gnome/evince/default" = {
            continuous = lib.mkDefault false;
            dual-page = lib.mkDefault true;
            sizing-mode = lib.mkDefault "fit-page";
          };

          "org/gnome/settings-daemon/plugins/color" = {
            night-light-enabled = lib.mkDefault true;
            night-light-schedule-automatic = lib.mkDefault true;
          };

          "org/gnome/settings-daemon/plugins/media-keys" = {
            custom-keybindings = lib.mkDefault [
              "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
            ];
          };

          "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
            binding = lib.mkDefault "<Control><Alt>t";
            command = lib.mkDefault "foot";
            name = lib.mkDefault "Terminal";
          };

          "org/gnome/shell" = {
            enabled-extensions = lib.mkDefault [
              "appindicatorsupport@rgcjonas.gmail.com"
              "blur-my-shell@aunetx"
              "burn-my-windows@schneegans.github.com"
              "clipboard-indicator@tudmotu.com"
              "dash-to-dock@micxgx.gmail.com"
              "gnome-ui-tune@itstime.tech"
              "gsconnect@andyholmes.github.io"
              "panel-corners@aunetx"
              "paperwm@paperwm.github.com"
              "search-light@icedman.github.com"
              "unite@hardpixel.eu"
              "user-theme@gnome-shell-extensions.gcampax.github.com"
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
            screenshot = lib.mkDefault [ "Print" ];
            screenshot-window = lib.mkDefault [ "<Alt>Print" ];
            show-screenshot-ui = lib.mkDefault [ "<Shift><Alt>5" ];
          };

          "org/gnome/shell/world-clocks" = {
            locations = lib.mkDefault [ ];
          };

          "org/gnome/tweaks" = {
            show-extensions-notice = lib.mkDefault false;
          };

          "system/locale" = {
            # TODO
            region = lib.mkDefault "en_DK.UTF-8";
          };

          # Plugins

          "org/gnome/shell/extensions/appindicator" = {
            icon-brightness = lib.mkDefault 0.0;
            icon-contrast = lib.mkDefault 0.0;
            icon-opacity = lib.mkDefault 240;
            icon-saturation = lib.mkDefault 0.0;
            icon-size = lib.mkDefault 0;
            legacy-tray-enabled = lib.mkDefault true;
          };
          "org/gnome/shell/extensions/burn-my-windows" = {
            active-profile = lib.mkDefault bmw_config;
            last-extension-version = lib.mkDefault 46;
            prefs-open-count = lib.mkDefault 1;
            preview-effect = lib.mkDefault "";
          };
          "org/gnome/shell/extensions/clipboard-indicator" = {
            display-mode = lib.mkDefault 2;
            move-item-first = lib.mkDefault false;
            notify-on-copy = lib.mkDefault false;
            pinned-on-bottom = lib.mkDefault false;
            preview-size = lib.mkDefault 48;
            strip-text = lib.mkDefault true;
          };
          "org/gnome/shell/extensions/dash-to-dock" = {
            always-center-icons = lib.mkDefault true;
            apply-custom-theme = lib.mkDefault false;
            background-color = lib.mkDefault "rgb(36,39,58)";
            background-opacity = lib.mkDefault 0.8;
            click-action = lib.mkDefault "skip";
            custom-background-color = lib.mkDefault true;
            custom-theme-shrink = lib.mkDefault false;
            customize-alphas = lib.mkDefault false;
            dash-max-icon-size = lib.mkDefault 48;
            dock-position = lib.mkDefault "BOTTOM";
            extend-height = lib.mkDefault true;
            height-fraction = lib.mkDefault 0.9;
            max-alpha = lib.mkDefault 0.8;
            middle-click-action = lib.mkDefault "launch";
            preferred-monitor = lib.mkDefault (-2);
            preferred-monitor-by-connector = lib.mkDefault "eDP-1";
            preview-size-scale = lib.mkDefault 0.0;
            scroll-action = lib.mkDefault "cycle-windows";
            shift-click-action = lib.mkDefault "launch";
            shift-middle-click-action = lib.mkDefault "launch";
            shortcut = lib.mkDefault [ ];
            shortcut-text = lib.mkDefault "";
            show-apps-always-in-the-edge = lib.mkDefault true;
            show-trash = lib.mkDefault false;
            transparency-mode = lib.mkDefault "DYNAMIC";
          };
          "org/gnome/shell/extensions/gnome-ui-tune" = {
            always-show-thumbnails = lib.mkDefault true;
            hide-search = lib.mkDefault true;
            increase-thumbnails-size = lib.mkDefault "200%";
            restore-thumbnails-background = lib.mkDefault true;
          };
          "org/gnome/shell/extensions/panel-corners" = {
            force-extension-values = lib.mkDefault false;
            panel-corner-opacity = lib.mkDefault 0.6;
            panel-corners = lib.mkDefault true;
            screen-corners = lib.mkDefault true;
          };
          "org/gnome/shell/extensions/paperwm" = {
            default-focus-mode = lib.mkDefault 2;
            disable-topbar-styling = lib.mkDefault false;
            edge-preview-enable = lib.mkDefault true;
            gesture-workspace-fingers = lib.mkDefault 3;
            last-used-display-server = lib.mkDefault "Wayland";
            open-window-position = lib.mkDefault 0;
            open-window-position-option-end = lib.mkDefault true;
            open-window-position-option-start = lib.mkDefault true;
            overview-ensure-viewport-animation = lib.mkDefault 1;
            overview-min-windows-per-row = lib.mkDefault 5;
            restore-attach-modal-dialogs = lib.mkDefault "true";
            restore-edge-tiling = lib.mkDefault "true";
            restore-workspaces-only-on-primary = lib.mkDefault "true";
            show-open-position-icon = lib.mkDefault true;
            show-workspace-indicator = lib.mkDefault false;
            use-default-background = lib.mkDefault true;
          };
          "org/gnome/shell/extensions/unite" = {
            autofocus-windows = lib.mkDefault false;
            extend-left-box = lib.mkDefault false;
            greyscale-tray-icons = lib.mkDefault false;
            hide-activities-button = lib.mkDefault "auto";
            hide-app-menu-icon = lib.mkDefault false;
            hide-window-titlebars = lib.mkDefault "always";
            icon-scale-workaround = lib.mkDefault false;
            notifications-position = lib.mkDefault "right";
            reduce-panel-spacing = lib.mkDefault false;
            restrict-to-primary-screen = lib.mkDefault true;
            show-appmenu-button = lib.mkDefault true;
            show-desktop-name = lib.mkDefault true;
            show-legacy-tray = lib.mkDefault true;
            show-window-buttons = lib.mkDefault "never";
            show-window-title = lib.mkDefault "always";
            use-activities-text = lib.mkDefault false;
            window-buttons-placement = lib.mkDefault "last";
            window-buttons-theme = lib.mkDefault "catppuccin";
          };
        };

        # todo
        home.file."${bmw_config}".text = lib.mkDefault ''
          [burn-my-windows-profile]
          aura-glow-enable-effect=true
          aura-glow-animation-time=300
          aura-glow-random-color=false
          aura-glow-saturation=1.0
          aura-glow-edge-size=0.4'';
      };
  };
}
