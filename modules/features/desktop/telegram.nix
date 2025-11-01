{ lib, ... }:
{
  flake.aspects.telegram.homeManager = { pkgs, ... }: {
    home.packages = lib.mkDefault [ pkgs.telegram-desktop ];
  };
}
