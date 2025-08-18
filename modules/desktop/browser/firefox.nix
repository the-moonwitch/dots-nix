{ inputs, ... }:
{
  flake.modules = inputs.self.lib.mkHomeFeature "firefox" (
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
