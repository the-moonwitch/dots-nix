{ lib, ... }:
{
  flake.aspects.claude-code.homeManager = { pkgs, ... }: {
    home.packages = lib.mkDefault [ pkgs.claude-code ];
  };
}
