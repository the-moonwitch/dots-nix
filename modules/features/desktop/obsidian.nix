{ lib, config, ... }:
{
  flake.aspects.obsidian = lib.mkMerge [
    (config.flake.lib.allowUnfreeFor [ "obsidian" ])
    {
      homeManager = { ... }: {
        programs.obsidian = {
          enable = lib.mkDefault true;
        };
      };
    }
  ];
}
