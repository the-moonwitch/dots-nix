{ inputs, config, ... }:
let
  inherit (config.cadence.lib)
    hostDef
    nixosFeature
    systemFeature
    homeFeature
    ;
  nixConfig = {
    extra-experimental-features = [
      "flakes"
      "nix-command"
    ];
  };
in
{
  flake-file = {
    inherit nixConfig;
    inputs.nix-index-database.url = "github:nix-community/nix-index-database";
  };

  cadence.features.nix = {
    lix = nixosFeature.system (
      { pkgs, ... }:
      {
        nixpkgs.overlays = [ (_final: prev: { nix = prev.lix; }) ];
        nix.package = pkgs.lix;
        programs.command-not-found.enable = true;
      }
    );

    nixpkgs = systemFeature (
      { host, ... }:
      {
        nixpkgs = {
          hostPlatform = host.system;
          config.allowUnfree = true;
        };
      }
    );

    nix-settings = systemFeature (
      { host, ... }:
      {
        nix.settings = {
          extra-experimental-features = [
            "flakes"
            "nix-command"
          ];
          trusted-users = [
            "root"
            "@wheel"
            host.username
          ];
        };
      }
    );

    homeManager = homeFeature {
      imports = [ inputs.nix-index-database.homeModules.nix-index ];

      programs = {
        nix-index.enable = true;
        nix-index-database.comma.enable = true;

        nh = {
          enable = true;
          flake = ./../../flake.nix;
        };
      };
    };
  };
}
