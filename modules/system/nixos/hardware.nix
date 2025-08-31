{ inputs, lib, ... }:
let
  inherit (inputs.cadence.lib)
    feature
    features
    ;
in
{
  cadence.dependencies.hardware = [
    "nixos/hardware"
    "nixos/powerManagement"
    "nixos/boot"
    "nixos/networking"
  ];

  flake.modules = features [
    (feature.nixos "nixos/hardware" {
      hardware = {
        enableAllHardware = true;
        enableAllFirmware = true;
        enableRedistributableFirmware = true;
      };
    })
    (feature.nixos "nixos/powerManagement" {
      powerManagement = {
        enable = lib.mkDefault true;
        cpuFreqGovernor = "schedutil";
      };
    })
    (feature.nixos "nixos/boot" {
      boot = {
        loader = {
          systemd-boot.enable = lib.mkDefault true;
          efi.canTouchEfiVariables = lib.mkDefault true;
        };
      };
    })
    (feature.nixos "nixos/networking" {
      networking = {
        networkmanager.enable = true;
        # useDHCP = true;
      };
    })
  ];
}
