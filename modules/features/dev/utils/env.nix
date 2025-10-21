{ inputs, ... }:
let
  inherit (inputs.cadence.lib.feature) homeManager;

  flake.modules = homeManager "devenv" (
    { pkgs, ... }:
    {
      home.packages = [ pkgs.devenv ];

      programs.direnv = {
        enable = true;
        mise.enable = true;
        nix-direnv.enable = false;
        config.global = {
          strict_env = true;
        };
      };
    }
  );
in
{
  inherit flake;
}
