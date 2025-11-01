{ inputs, lib, ... }:
{
  flake.aspects.moth = {
    nixos = {
      imports = [
        (inputs.nixpkgs + "/nixos/modules/installer/scan/not-detected.nix")
      ];

      boot.initrd.availableKernelModules = lib.mkDefault [
        "nvme"
        "xhci_pci"
        "usb_storage"
        "sd_mod"
        "rtsx_pci_sdmmc"
      ];
      boot.initrd.kernelModules = lib.mkDefault [ ];
      boot.kernelModules = lib.mkDefault [ "kvm-amd" ];
      boot.extraModulePackages = lib.mkDefault [ ];

      fileSystems."/" = {
        device = "/dev/disk/by-uuid/56ae634a-36ab-433e-a3d9-102f6e8a5bbd";
        fsType = "btrfs";
        options = lib.mkDefault [ "subvol=@" ];
      };

      boot.initrd.luks.devices."luks-1574e482-dea1-4e63-a6da-e115105b41c0".device =
        "/dev/disk/by-uuid/1574e482-dea1-4e63-a6da-e115105b41c0";

      fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/0EDC-15AC";
        fsType = "vfat";
        options = lib.mkDefault [
          "fmask=0077"
          "dmask=0077"
        ];
      };

      swapDevices = lib.mkDefault [ ];
    };

    homeManager = {
      dconf.settings = {

        "org/gnome/settings-daemon/plugins/media-keys" = {
          custom-keybindings = lib.mkDefault [
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
          ];
        };

        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
          # Copilot button
          binding = lib.mkDefault "<Shift><Super>TouchpadOff";
          command = lib.mkDefault "foot";
          name = lib.mkDefault "Terminal";
        };

        "org/gnome/settings-daemon/plugins/power" = {
          power-button-action = lib.mkDefault "nothing";
        };
      };
    };
  };
}
