{ inputs, ... }:
with inputs.self.lib;
{
  flake.modules =
    let
      stateVersion = "25.05";
    in
    mkFeature "base" {

      home = {
        home = { inherit stateVersion; };
      };

      nixos = {
        system = { inherit stateVersion; };
      };

      darwin = {
        system.stateVersion = 6;
      };
    };
}
