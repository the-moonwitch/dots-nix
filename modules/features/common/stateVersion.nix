{ inputs, ... }:
let
  inherit (inputs.cadence.lib) feature;
  flake.modules = feature "base/stateVersion" {
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
in
{
  inherit flake;
}
