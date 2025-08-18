{ inputs, ... }:
with inputs.self.lib;
{
  flake.modules = mkNixosFeature "unfree" (inputs.self.lib.declareUnfree [ ]);
}
