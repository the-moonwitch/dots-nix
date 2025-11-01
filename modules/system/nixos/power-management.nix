{ lib, ... }:
{
  flake.aspects."system/nixos/power-management".nixos = {
    powerManagement = {
      enable = lib.mkDefault true;
      powertop.enable = lib.mkDefault true;
      cpuFreqGovernor = lib.mkDefault "schedutil";
    };
    hardware.system76.enableAll = lib.mkDefault true;
    services.power-profiles-daemon.enable = lib.mkDefault true;
  };
}
