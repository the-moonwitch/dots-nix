{ lib, ... }:
{
  flake.aspects.nodejs.homeManager = { pkgs, ... }: {
    home.packages = lib.mkDefault [ pkgs.nodejs ];
  };
}
