{ inputs, ... }:
let
  inherit (inputs.cadence.lib) feature features;
  nixConfig = {
    extra-experimental-features = [
      "flakes"
      "nix-command"
    ];
  };

  flake-file = {
    inherit nixConfig;
    inputs.nix-index-database.url = "github:nix-community/nix-index-database";
  };

  cadence.dependencies.nix = [
    "nix/lix"
    "nix/nixpkgs"
    "nix/nix-settings"
  ];

  flake.modules = features [
    (feature.system "nix/lix" (
      { pkgs, ... }:
      {
        nixpkgs.overlays = [ (_final: prev: { nix = prev.lix; }) ];
        nix.package = pkgs.lix;
        programs.command-not-found.enable = true;
      }
    ))
    (feature.system "nix/nixpkgs" (
      { host, ... }:
      {
        nixpkgs = {
          hostPlatform = host.system;
        };
      }
    ))
    (feature.system "nix/nix-settings" (
      { host, config, ... }:
      {
        services.onepassword-secrets.secrets.nixGhToken = {
          reference = "op://Host Secrets/Nix GitHub PAT/credential";
          group = "onepassword-secrets";
          mode = "0640";
        };

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
          extra-access-tokens = [
            "!include ${config.services.onepassword-secrets.secretPaths.nixGhToken}"
          ];
        };
      }
    ))
    (feature.homeManager "nix" {
      imports = [ inputs.nix-index-database.homeModules.nix-index ];

      programs = {
        nix-index.enable = true;
        nix-index-database.comma.enable = true;

        nh = {
          enable = true;
          flake = ./../../flake.nix;
        };
      };
    })
  ];
in
{
  inherit flake flake-file cadence;
}
