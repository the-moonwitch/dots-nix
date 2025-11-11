{ lib, ... }:
{
  flake.aspects.foot.homeManager = { ... }: {
    programs.foot = {
      enable = lib.mkDefault true;
      settings = {
        main = {
          font = lib.mkForce "Maple Mono NF:size=11:fontfeatures=cv01:fontfeatures=cv05:fontfeatures=cv09";
        };
      };
    };
  };
}
