{ inputs, ... }:
{
  flake.modules = inputs.self.lib.mkNixosFeature "hardware" {
    hardware.enableAllHardware = true;
    hardware.enableAllFirmware = true;
    hardware.enableRedistributableFirmware = true;
    nixpkgs.config.allowUnfree = true;
  };
}
