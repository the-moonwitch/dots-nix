{ inputs, lib, ... }:
with inputs.self.lib;
{
  flake.modules = mkNixosFeature "networking" {
    networking.networkmanager.enable = true;
    networking.useDHCP = lib.mkDefault true;
  };
}
