{ inputs, ... }:
let
  inherit (inputs.cadence.lib.feature) homeManager;
  flake.modules = homeManager "dev/nix" (
    { pkgs, ... }:
    {
      home = {
        packages = with pkgs; [ nil ];
      };
    }
  );
in
{
  inherit flake;
}
