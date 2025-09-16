{ inputs, ... }:
let
  inherit (inputs.cadence.lib.feature) homeManager;
  flake.modules = homeManager "dev/python" (
    { pkgs, ... }:
    {
      programs.uv.enable = true;
      programs.fish.shellInit = ''
        uv python install --preview-features python-install-default --default > /dev/null 2>&1 || true 
      '';
    }
  );
in
{
  inherit flake;
}
