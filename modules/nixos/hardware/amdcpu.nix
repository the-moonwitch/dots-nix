{ ... }:
{
  flake.modules.nixos.amdcpu = {
    boot.kernelModules = [ "kvm-amd" ];
    hardware.cpu.amd.updateMicrocode = true;
  };
}
