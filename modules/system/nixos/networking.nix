{ lib, ... }:
{
  flake.aspects."system/nixos/networking".nixos = {
    networking = {
      networkmanager.enable = lib.mkDefault true;
    };
  };
}
