{ inputs, ... }:
let
  inherit (inputs.cadence.lib.feature) homeManager;

  flake.modules = (
    homeManager "obsidian" (
      { ... }:
      {
        programs.obsidian = {
          enable = true;
        };
      }
    )
  );
in
{
  inherit flake;
}
