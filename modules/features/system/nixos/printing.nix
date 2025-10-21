{ inputs, ... }:
let
  inherit (inputs.cadence.lib.feature) nixos;
  flake.modules = nixos "printing" { services.printing.enable = true; };
in
{
  inherit flake;
}
