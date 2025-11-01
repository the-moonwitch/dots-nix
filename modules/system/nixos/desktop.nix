{ lib, ... }:
{
  flake.aspects."system/nixos/desktop".nixos = {
    programs.dconf.enable = lib.mkDefault true;
    services.xserver.enable = lib.mkDefault true;
  };
}
