{ inputs, ... }:
let
  inherit (inputs.cadence.lib.feature) system;
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

  flake.modules = system "unfree" { nixpkgs.config.allowUnfree = true; };

in
{
  inherit flake flake-file;
}
