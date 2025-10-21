{ inputs, ... }:
let
  inherit (inputs.cadence.lib.feature) homeManager;
  flake.modules = homeManager "telegram" (
    { pkgs, ... }:
    {
      home = {
        packages = with pkgs; [ telegram-desktop ];
      };
    }
  );
in
{
  inherit flake;
}
