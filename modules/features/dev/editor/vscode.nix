{ inputs, ... }:
let
  inherit (inputs.cadence.lib.feature) homeManager;
  flake.modules = homeManager "vscode" { programs.vscode.enable = true; };
in
{
  inherit flake;
}
