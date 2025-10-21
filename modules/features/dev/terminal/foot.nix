{ inputs, ... }:
let
  inherit (inputs.cadence.lib.feature) homeManager;
  flake.modules = homeManager "foot" {
    programs.foot = {
      enable = true;
    };
  };
in
{
  inherit flake;
}
