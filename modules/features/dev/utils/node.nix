{ inputs, ... }:
let
  inherit (inputs.cadence.lib.feature) homeManager;
  flake.modules = homeManager "nodejs" (
    { pkgs, ... }:
    {
      home.packages = [ pkgs.nodejs ];
    }
  );
in
{
  inherit flake;
}
