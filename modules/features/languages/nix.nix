{ lib, ... }:
{
  flake.aspects.nix.homeManager = { pkgs, ... }: {
    home.packages = lib.mkDefault [ pkgs.nil ];
  };
}
