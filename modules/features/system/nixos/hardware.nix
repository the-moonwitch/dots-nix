{ inputs, lib, ... }:
let
  inherit (inputs.cadence.lib) feature features;
  inherit (feature) nixos;

  cadence.dependencies = {
    nixos = [ "nixos/hardware" ];
    "nixos/hardware" = [
      "nixos/powerManagement"
      "nixos/boot"
      "nixos/networking"
    ];
  };

  flake.modules = features [
    (nixos "nixos/hardware" (
      { pkgs, ... }:
      {
        environment.systemPackages = (with pkgs; [ lm_sensors ]);
        hardware = {
          enableAllHardware = true;
          enableAllFirmware = true;
          enableRedistributableFirmware = true;
          sensor.iio.enable = true;
        };

      }
    ))
    (nixos "nixos/powerManagement" {
      powerManagement = {
        enable = true;
        powertop.enable = true;
        cpuFreqGovernor = "schedutil";
      };
      hardware.system76.enableAll = true;
      services.power-profiles-daemon.enable = true;
    })
    (nixos "nixos/boot" {
      boot = {
        loader = {
          systemd-boot.enable = lib.mkDefault true;
          efi.canTouchEfiVariables = lib.mkDefault true;
        };
      };
    })
    (nixos "nixos/networking" {
      networking = {
        networkmanager.enable = true;
      };
    })
  ];
in
{
  inherit flake cadence;
}
