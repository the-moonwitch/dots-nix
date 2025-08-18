{ inputs, ... }:
{
  flake.modules = inputs.self.lib.mkNixosFeature "boot" {
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
  };
}
