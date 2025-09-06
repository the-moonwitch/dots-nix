{ inputs, ... }:
let
  inherit (inputs.cadence.lib.feature) homeManager;
  flake.modules = homeManager "spotify" (
    { pkgs, ... }:
    {
      home = {
        packages = with pkgs; [ spotify ];
      };
    }
  );
in
{
  inherit flake;
}
