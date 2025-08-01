{ inputs, ... }:
{
  flake.modules.nixos.unfree = inputs.self.lib.declareUnfree [ ];
}
