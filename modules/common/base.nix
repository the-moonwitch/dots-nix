{ inputs, config, ... }:
let
  inherit (config.cadence.lib) hostDef systemFeature;
in
{
  cadence = {
    dependencies.base = [
      "nix"
      "nixos"
    ];
    features.base = {
      hostname = systemFeature (
        { host, ... }:
        {
          networking.hostName = host.hostname;
        }
      );
      stateVersion = {
        nixos = {
          system.stateVersion = "25.05";
        };

        darwin = {
          system.stateVersion = 6;
        };

        homeManager = {
          home.stateVersion = "25.05";
        };
      };
      homePkgs = systemFeature {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      };
    };
  };
}
