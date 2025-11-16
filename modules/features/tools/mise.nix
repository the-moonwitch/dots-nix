{ lib, ... }:
{
  flake.aspects.mise.homeManager = {
    programs.mise = {
      enable = lib.mkDefault true;
    };
  };
}
