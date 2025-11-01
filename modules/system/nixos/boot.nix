{ lib, ... }:
{
  flake.aspects."system/nixos/boot".nixos = {
    boot = {
      loader = {
        systemd-boot.enable = lib.mkDefault true;
        efi.canTouchEfiVariables = lib.mkDefault true;
      };
    };
  };
}
