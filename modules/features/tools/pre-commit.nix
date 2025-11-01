{ lib, ... }:
{
  flake.aspects.pre-commit.homeManager = { pkgs, ... }: {
    home.packages = lib.mkDefault [ pkgs.pre-commit ];
  };
}
