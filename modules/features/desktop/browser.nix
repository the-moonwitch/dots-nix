{ inputs, ... }:
{
  # Default browser = floorp
  flake.dependencies.browser = [ "browser/floorp" ];

  imports = [
    {
      flake.modules = inputs.self.lib.mkHomeFeature "browser/firefox" (
        { pkgs, ... }:
        {

          programs.firefox = {
            enable = true;
            package = pkgs.firefox.override {
              nativeMessagingHosts = [
                pkgs.gnome-browser-connector
                # pkgs.tridactyl-native
              ];
            };
            languagePacks = [
              "pl"
              "en-US"
            ];
          };
        }
      );
    }
    {
      flake.modules = inputs.self.lib.mkHomeFeature "browser/floorp" (
        { ... }:
        {

          programs.floorp = {
            enable = true;
            enableGnomeExtensions = true;
            languagePacks = [
              "en-US"
              "pl"
            ];
          };
        }
      );
    }
  ];
}
