{ inputs, ... }:
let
  inherit (inputs.cadence.lib) feature features;
  inherit (feature) nixos;

  cadence.dependencies = {
    "desktop" = [
      # Base deps
      "desktop/xserver"
    ];
  };

  flake.modules = features [
    (nixos "desktop/xserver" {
      programs.dconf.enable = true;
      services.xserver.enable = true;
    })
  ];
in
{
  inherit cadence flake;
}
