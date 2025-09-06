{ inputs, ... }:
let
  inherit (inputs.cadence.lib) feature features;

  cadence.dependencies.moth = [
    "moth/kernel"
    "moth/filesystems"
  ];

  flake.modules = features [
    (feature.nixos "moth/kernel" {
      imports = [
        (inputs.nixpkgs + "/nixos/modules/installer/scan/not-detected.nix")
      ];

      boot.initrd.availableKernelModules = [
        "nvme"
        "xhci_pci"
        "usb_storage"
        "sd_mod"
        "rtsx_pci_sdmmc"
      ];
      boot.initrd.kernelModules = [ ];
      boot.kernelModules = [ "kvm-amd" ];
      boot.extraModulePackages = [ ];
    })

    (feature.nixos "moth/filesystems" {
      fileSystems."/" = {
        device = "/dev/disk/by-uuid/56ae634a-36ab-433e-a3d9-102f6e8a5bbd";
        fsType = "btrfs";
        options = [ "subvol=@" ];
      };

      boot.initrd.luks.devices."luks-1574e482-dea1-4e63-a6da-e115105b41c0".device =
        "/dev/disk/by-uuid/1574e482-dea1-4e63-a6da-e115105b41c0";

      fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/0EDC-15AC";
        fsType = "vfat";
        options = [
          "fmask=0077"
          "dmask=0077"
        ];
      };

      swapDevices = [ ];
    })
  ];
in
{
  inherit flake cadence;
}
