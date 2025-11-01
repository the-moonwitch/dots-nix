{ lib, ... }:
{
  flake.aspects.foot.homeManager = { ... }: {
    programs.foot = {
      enable = lib.mkDefault true;
    };
  };
}
