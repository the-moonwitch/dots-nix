{ inputs, config, ... }:
let
  inherit (config.cadence.lib) hostDef systemFeature;
in
{
  imports = [
    inputs.cadence.flakeModules.default
  ];

  flake-file = {
    description = "Ninix";
    inputs = {
      cadence.url = "github:the-moonwitch/cadence";
    };
  };

  cadence = {
    dependencies.base = [
      "nix"
      "nixos"
    ];
    features.base = {
      hostname = systemFeature (
        { host, ... }:
        {
          networking.hostName = (hostDef host).hostname;
        }
      );
      stateVersion = {
        nixos = {
          system.stateVersion = "25.05";
        };

        darwin = {
          system.stateVersion = 6;
        };

        home = {
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
