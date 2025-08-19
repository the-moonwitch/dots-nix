{ inputs, ... }:
with inputs.self.lib;
{
  flake.modules = mkOSAgnosticFeature "unfree" (
    inputs.self.lib.declareUnfree [ ]
  );
}
