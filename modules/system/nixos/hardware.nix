{ lib, ... }:
{
  flake.aspects."system/nixos/hardware".nixos = { pkgs, ... }: {
    environment.systemPackages = lib.mkDefault (with pkgs; [ lm_sensors ]);
    hardware = {
      enableAllHardware = lib.mkDefault true;
      enableAllFirmware = lib.mkDefault true;
      enableRedistributableFirmware = lib.mkDefault true;
      sensor.iio.enable = lib.mkDefault true;
    };
  };
}
