{ inputs, ... }:
let
  inherit (inputs.cadence.lib.feature) nixos;
  flake.modules = nixos "macos-keys" {
    services.keyd = {
      enable = true;
      keybaords.default = {
        ids = [ "*" ];
        settings = {
          # ...
        };
      };
    };
  };
in
{
  inherit flake;
}
