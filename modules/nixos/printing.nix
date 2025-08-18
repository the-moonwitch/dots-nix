{ inputs, ... }:
with inputs.self.lib;
{
  flake.modules = mkNixosFeature "printing" { services.printing.enable = true; };
}
