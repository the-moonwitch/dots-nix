{ lib, ... }:
{
  flake.aspects."system/nixos/amdcpu".nixos = {
    boot.kernelModules = lib.mkDefault [ "kvm-amd" ];
    hardware.cpu.amd.updateMicrocode = lib.mkDefault true;
  };
}
