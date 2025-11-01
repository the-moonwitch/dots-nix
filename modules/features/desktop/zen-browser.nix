{ lib, inputs, ... }:
{
  flake-file.inputs = {
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
  };

  flake.aspects.zen-browser = {
    nixos = { ... }: {
      environment.etc = {
        "1password/custom_allowed_browsers" = {
          text = ''
            .zen-wrapped
          '';
          mode = "0755";
        };
      };
    };

    homeManager =
      { hostDef, pkgs, ... }:
      {
        imports = [ inputs.zen-browser.homeModules.default ];

        xdg.mimeApps =
          let
            value =
              let
                zen-browser = inputs.zen-browser.packages.${hostDef.system}.default;
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
            associations.added = lib.mkDefault associations;
            defaultApplications = lib.mkDefault associations;
          };

        programs.zen-browser = {
          enable = lib.mkDefault true;
          nativeMessagingHosts = lib.mkDefault (
            [
              # pkgs.tridactyl-native
            ]
            ++ lib.optionals (hostDef.class != "darwin") [ pkgs.gnome-browser-connector ]
          );
          policies = lib.mkDefault {
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
          languagePacks = [
            "pl"
            "en-US"
          ];
          home.sessionVariables = {
            MOZ_USE_XINPUT2 = "1";
          };
        };
      };
  };
}
