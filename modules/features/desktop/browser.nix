{ lib, inputs, ... }:
let
  inherit (inputs.cadence.lib.feature) homeManager;

  # Default browser = firefox
  cadence.dependencies = {
    browser = [ ];
    "browser[firefox]" = [ "browser" ];
  };

  flake.modules = (
    homeManager "browser[firefox]" (
      { host, pkgs, ... }:
      {
        programs.firefox = {
          enable = true;
          package = pkgs.firefox.override {
            nativeMessagingHosts = [
              # pkgs.tridactyl-native
            ]
            ++ lib.optional (host.class != "darwin") pkgs.gnome-browser-connector;
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
    )
  );
in
{
  inherit flake cadence;
}
