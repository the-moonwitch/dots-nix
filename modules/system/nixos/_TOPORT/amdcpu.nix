{ inputs, ... }:
{
  flake.modules = inputs.self.lib.mkNixosFeature "amdcpu" {
    boot.kernelModules = [ "kvm-amd" ];
    hardware.cpu.amd.updateMicrocode = true;
  };
}
