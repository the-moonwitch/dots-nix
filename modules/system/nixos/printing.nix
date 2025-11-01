{ lib, ... }:
{
  flake.aspects."system/nixos/printing".nixos = {
    services.printing.enable = lib.mkDefault true;
  };
}
