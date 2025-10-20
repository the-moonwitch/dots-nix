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
                # pkgs.tridactyl-native
              ]
              ++ (
                if pkgs.stdenvNoCC.isDarwin then [ ] else [ pkgs.gnome-browser-connector ]
              );
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
        { pkgs, ... }:
        {

          programs.floorp = {
            enable = !pkgs.stdenvNoCC.isDarwin;
            package = pkgs.floorp.override {
              # packageVersion = "12.1.2";
              # src = pkgs.fetchFromGitHub {
              #   owner = "Floorp-Projects";
              #   repo = "Floorp";
              #   fetchSubmodules = true;
              #   rev = "v12.1.2";
              # };
              nativeMessagingHosts = [
                # pkgs.tridactyl-native
              ]
              ++ (
                if pkgs.stdenvNoCC.isDarwin then [ ] else [ pkgs.gnome-browser-connector ]
              );
            };
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
