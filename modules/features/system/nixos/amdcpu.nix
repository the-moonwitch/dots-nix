{ inputs, ... }:
let
  inherit (inputs.cadence.lib.feature) nixos;
  flake.modules = nixos "amdcpu" {
    boot.kernelModules = [ "kvm-amd" ];
    hardware.cpu.amd.updateMicrocode = true;
  };
in
{
  inherit flake;
}
