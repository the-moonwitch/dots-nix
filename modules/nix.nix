{ inputs, config, ... }:
let
  inherit (config.cadence.lib)
    hostDef
    nixosFeature
    systemFeature
    homeFeature
    ;
in
{
  flake-file.inputs.nix-index-database.url = "github:nix-community/nix-index-database";

  cadence.features.nix = {
    lix = nixosFeature.system (
      { pkgs, ... }:
      {
        nixpkgs.overlays = [ (_final: prev: { nix = prev.lix; }) ];
        nix.package = pkgs.lix;
        programs.command-not-found.enable = true;
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
            (hostDef host).username
          ];
        };
      }
    );

    home = homeFeature {
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
