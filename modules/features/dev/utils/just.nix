{ inputs, ... }:
let
  inherit (inputs.cadence.lib.feature) homeManager;
  flake.modules = homeManager "foot" (
    { pkgs, ... }:
    {
      home.packages = [ pkgs.just ];
    }
  );
in
{
  inherit flake;
}
