{ lib, ... }:
{
  flake.aspects.mise.homeManager = { pkgs, ... }: {
    home.packages = lib.mkDefault [ pkgs.mise ];
  };
}
