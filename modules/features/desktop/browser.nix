{ lib, inputs, ... }:
let
  inherit (inputs.cadence.lib) feature features;
  inherit (feature) homeManager;

  flake-file.inputs = {
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
  };

  # Default browser = firefox
  cadence.dependencies = {
    browser = [ "browser" ];
    "browser[firefox]" = [ "browser" ];
    "browser[zen]" = [ "browser" ];
  };

  flake.modules = features [
    (homeManager "browser[firefox]" (
      { host, pkgs, ... }:
      {
        programs.firefox = {
          enable = true;
          package = pkgs.firefox.override {
            nativeMessagingHosts = [
              # pkgs.tridactyl-native
            ]
            ++ lib.optionals (host.class != "darwin") [ pkgs.gnome-browser-connector ];
          };

          languagePacks = [
            "pl"
            "en-US"
          ];
        };

        home.sessionVariables = {
          MOZ_USE_XINPUT2 = "1";
        };
      }
    ))

    (feature "browser[zen]" {

      nixos.environment.etc = {
        "1password/custom_allowed_browsers" = {
          text = ''
            .zen-wrapped
          '';
          mode = "0755";
        };
      };

      homeManager =
        { host, pkgs, ... }:
        {
          imports = [ inputs.zen-browser.homeModules.default ];

          xdg.mimeApps =
            let
              value =
                let
                  zen-browser = inputs.zen-browser.packages.${host.system}.default;
                in
                zen-browser.meta.desktopFileName;

              associations = builtins.listToAttrs (
                map (name: { inherit name value; }) [
                  "application/x-extension-shtml"
                  "application/x-extension-xhtml"
                  "application/x-extension-html"
                  "application/x-extension-xht"
                  "application/x-extension-htm"
                  "x-scheme-handler/unknown"
                  "x-scheme-handler/mailto"
                  "x-scheme-handler/chrome"
                  "x-scheme-handler/about"
                  "x-scheme-handler/https"
                  "x-scheme-handler/http"
                  "application/xhtml+xml"
                  "application/json"
                  "text/plain"
                  "text/html"
                ]
              );
            in
            {
              associations.added = associations;
              defaultApplications = associations;
            };

          programs.zen-browser = {
            enable = true;
            nativeMessagingHosts = [
              # pkgs.tridactyl-native
            ]
            ++ lib.optionals (host.class != "darwin") [ pkgs.gnome-browser-connector ];
            policies = {
              DisableAppUpdate = true;
              DisableFeedbackCommands = true;
              DisableFirefoxStudies = true;
              DisablePocket = true;
              DisableTelemetry = true;
              DontCheckDefaultBrowser = true;
              NoDefaultBookmarks = true;
              OfferToSaveLogins = false;
              EnableTrackingProtection = {
                Value = true;
                Locked = false;
                Cryptomining = true;
                Fingerprinting = true;
                EmailTracking = true;
                SuspectedFingerprinting = true;
              };
            };
          };
        };
    })
  ];
in
{
  inherit flake flake-file cadence;
}
