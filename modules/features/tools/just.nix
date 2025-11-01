{ lib, ... }:
{
  flake.aspects.just.homeManager = { pkgs, ... }: {
    home.packages = lib.mkDefault [ pkgs.just ];
  };
}
