{ inputs, ... }:
{
  flake.modules = inputs.self.lib.mkNixosFeature "moth" {
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
  };
}
