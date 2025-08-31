{ self, lib, ... }:
let
  inherit (self.lib)
    nixosFeature
    ;
in
{
  flake.features.nixos = {
    hardware = nixosFeature.system {
      hardware = {
        enableAllHardware = true;
        enableAllFirmware = true;
        enableRedistributableFirmware = true;
      };
    };
    powerManagement = nixosFeature.system {
      powerManagement = {
        enable = lib.mkDefault true;
        cpuFreqGovernor = "schedutil";
      };
    };
    boot = nixosFeature.system {
      boot.loader = {
        systemd-boot.enable = lib.mkDefault true;
        efi.canTouchEfiVariables = lib.mkDefault true;
      };
    };
    networking = nixosFeature.system {
      networking = {
        networkmanager.enable = true;
        # useDHCP = true;
      };
    };
  };
}
