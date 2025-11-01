{ lib, ... }:
{
  flake.aspects.jujutsu.homeManager = { hostDef, ... }: {
    programs.jujutsu = {
      enable = lib.mkDefault true;
      settings = {
        user = {
          name = lib.mkDefault "ines";
          email = lib.mkDefault "ines@moonwit.ch";
        };
      };
    };
  };
}
