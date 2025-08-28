{ inputs, config, ... }:
let
  inherit (config.cadence.lib) hostDef;
  nixConfig = {
    extra-experimental-features = [
      "flakes"
      "nix-command"
    ];
  };
in
{
  imports = [ 
    inputs.cadence.flakeModules.default
  ];

  flake-file = {
    inherit nixConfig;
    description = "Ninix";
    inputs = {
      cadence.url = "github:the-moonwitch/cadence";
      nix-index-database.url = "github:nix-community/nix-index-database";
    };
  };

  cadence.dependencies.base = [ "nix" ];
  cadence.features.base =
    let
      hostnameModule =
        { host, ... }:
        {
          networking.hostName = (hostDef host).hostname;
        };
    in
    {

      hostname = {
        nixos = hostnameModule;
        darwin = hostnameModule;
      };

      stateVersion = {
        nixos =
          { host, ... }:
          {
            system.stateVersion = "25.05";
            nixpkgs.hostPlatform = (hostDef host).system;
          };

        darwin = {
          system.stateVersion = 6;
        };

        home = {
          home.stateVersion = "25.05";
        };
      };
      home =
        let
          hmSettings = {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          };
        in
        {
          nixos = hmSettings;
          darwin = hmSettings;
        };

    };
}
