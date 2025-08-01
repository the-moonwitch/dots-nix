{
  flake.modules.nixos.hardware = {
    hardware.enableAllHardware = true;
    hardware.enableAllFirmware = true;
    hardware.enableRedistributableFirmware = true;
    nixpkgs.config.allowUnfree = true;
  };
}
