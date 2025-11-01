{ lib, ... }:
{
  # Prompt
  flake.aspects.starship.homeManager = { ... }: {
    programs.starship = {
      enable = lib.mkDefault true;
      enableFishIntegration = lib.mkDefault true;
      settings = lib.mkDefault { };
    };
  };
}
