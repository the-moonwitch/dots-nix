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
    "desktop[gnome]" = [ "desktop" ];
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
            gsconnect
            gnome-40-ui-improvements
            panel-corners
            paperwm
            burn-my-windows
            search-light
            clipboard-indicator
            unite
          ]);

        environment.gnome.excludePackages = with pkgs; [ epiphany ];

        systemd.services = {
          "getty@tty1".enable = false;
          "autovt@tty1".enable = false;
        };
      }
    ))
    (homeManager "desktop[gnome]" (
      {
        lib,
        host,
        config,
        ...
      }:

      let
        bmw_config = "${config.xdg.configHome}/burn-my-windows/profiles/${host.username}.conf";
        gtk4_css = "${config.xdg.configHome}/gtk-4.0/gtk.css";
      in
      {
        programs.gnome-shell.enable = true;
        gtk.gtk4.extraCss = "@import url('/run/current-system/sw/share/gnome-shell/extensions/unite@hardpixel.eu/styles/gtk4/buttons-right/always.css'";
        home.file."${gtk4_css}".force = lib.mkForce true;

        dconf.settings = with lib.hm.gvariant; {

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

          # Plugins

          "org/gnome/shell/extensions/appindicator" = {
            icon-brightness = 0.0;
            icon-contrast = 0.0;
            icon-opacity = 240;
            icon-saturation = 0.0;
            icon-size = 0;
            legacy-tray-enabled = true;
          };
          "org/gnome/shell/extensions/burn-my-windows" = {
            active-profile = bmw_config;
            last-extension-version = 46;
            prefs-open-count = 1;
            preview-effect = "";
          };
          "org/gnome/shell/extensions/clipboard-indicator" = {
            display-mode = 2;
            move-item-first = false;
            notify-on-copy = false;
            pinned-on-bottom = false;
            preview-size = 48;
            strip-text = true;
          };
          "org/gnome/shell/extensions/dash-to-dock" = {
            always-center-icons = true;
            apply-custom-theme = false;
            background-color = "rgb(36,39,58)";
            background-opacity = 0.8;
            click-action = "skip";
            custom-background-color = true;
            custom-theme-shrink = false;
            customize-alphas = false;
            dash-max-icon-size = 48;
            dock-position = "BOTTOM";
            extend-height = true;
            height-fraction = 0.9;
            max-alpha = 0.8;
            middle-click-action = "launch";
            preferred-monitor = -2;
            preferred-monitor-by-connector = "eDP-1";
            preview-size-scale = 0.0;
            scroll-action = "cycle-windows";
            shift-click-action = "launch";
            shift-middle-click-action = "launch";
            shortcut = [ ];
            shortcut-text = "";
            show-apps-always-in-the-edge = true;
            show-trash = false;
            transparency-mode = "DYNAMIC";
          };
          "org/gnome/shell/extensions/gnome-ui-tune" = {
            always-show-thumbnails = true;
            hide-search = true;
            increase-thumbnails-size = "200%";
            restore-thumbnails-background = true;
          };
          "org/gnome/shell/extensions/panel-corners" = {
            force-extension-values = false;
            panel-corner-opacity = 0.6;
            panel-corners = true;
            screen-corners = true;
          };
          "org/gnome/shell/extensions/paperwm" = {
            default-focus-mode = 2;
            disable-topbar-styling = false;
            edge-preview-enable = true;
            gesture-workspace-fingers = 3;
            last-used-display-server = "Wayland";
            open-window-position = 0;
            open-window-position-option-end = true;
            open-window-position-option-start = true;
            overview-ensure-viewport-animation = 1;
            overview-min-windows-per-row = 5;
            restore-attach-modal-dialogs = "true";
            restore-edge-tiling = "true";
            restore-workspaces-only-on-primary = "true";
            show-open-position-icon = true;
            show-workspace-indicator = false;
            use-default-background = true;
          };
          "org/gnome/shell/extensions/unite" = {
            autofocus-windows = false;
            extend-left-box = false;
            greyscale-tray-icons = false;
            hide-activities-button = "auto";
            hide-app-menu-icon = false;
            hide-window-titlebars = "always";
            icon-scale-workaround = false;
            notifications-position = "right";
            reduce-panel-spacing = false;
            restrict-to-primary-screen = true;
            show-appmenu-button = true;
            show-desktop-name = true;
            show-legacy-tray = true;
            show-window-buttons = "never";
            show-window-title = "always";
            use-activities-text = false;
            window-buttons-placement = "last";
            window-buttons-theme = "catppuccin";
          };
        };

        # todo
        home.file."${bmw_config}".text = ''
          [burn-my-windows-profile]
          aura-glow-enable-effect=true
          aura-glow-animation-time=300
          aura-glow-random-color=false
          aura-glow-saturation=1.0
          aura-glow-edge-size=0.4'';
      }
    ))
  ];
in
{
  inherit cadence flake;
}
