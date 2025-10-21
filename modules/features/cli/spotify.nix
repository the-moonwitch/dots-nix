{ inputs, ... }:
let
  inherit (inputs.cadence.lib.feature) homeManager;
  flake.modules = homeManager "spotify" {
    programs.spotify-player.enable = true;
  };
in
{
  inherit flake;
}
